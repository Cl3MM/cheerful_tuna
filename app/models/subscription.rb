class Subscription < ActiveRecord::Base

  #include ModelStatus
  #include Scrollable

  attr_accessible :current, :documents_attributes, :end_date,
                  :cost, :owner_id, :owner_type, :paid,
                  :start_date, :status
  belongs_to  :owner, polymorphic: true, inverse_of: :subscriptions
  has_many    :documents, as: :owner#, inverse_of: :owner

  accepts_nested_attributes_for :documents

  validate                :start_date,  presence: true
  after_validation        :validate_start_date
  before_save             :set_end_date, :set_status_before_save
  before_update           :set_end_date, :set_status_before_save

  default_scope order: 'start_date DESC'
  scope :current, where( current: true).limit(1)

  def designations
    @_designations ||= (documents.any? ? documents.map{ |d| d.designation.to_sym } : [])
  end

  private

  # Ugly code :(
  def initialize_status_before_save
    debug "initialize_status_before_save"
    if pending_payment? && paid?
      paid = true
      status = :payment_received
    else
      paid = false
      status = if documents.any?
                 # what if invoice but no MBF/SA ?
                 if designations.include? :invoice # Invoice?
                   :pending_payment
                 elsif (designations & [ :membership_form, :service_agreement ]).size == 2 #SA & MBF?
                   :pending_invoice
                 elsif designations.include? :membership_form # MBF ?
                   :pending_sa
                 else # SA ?
                   :pending_mbf
                 end
               else
                 :pending_documents
               end
    end
    [ paid, status ]
  end

  def set_status_before_save
    debug "set_status_before_save"
    unless payment_received?
      paid, status = false, :new
      if documents.size == 3 && paid?
        paid, status = true, :payment_received
      else
        paid, status = initialize_status_before_save
      end
      self.status = status
      self.paid   = paid
    end
    true
  end

  def set_end_date
    debug "set_end_date"
    self.end_date = if paid? or expired?
                      Date.current.end_of_year
                    elsif self.created_at.nil?
                      Date.current + 30.days
                    else
                      self.created_at.to_date + 30.days
                    end
    true
  end

  def validate_start_date
    debug "validate_start_date"
    date_down = Date.current - 3.months
    date_up   = Date.current + 3.months
    if ( date_down .. date_up ).cover? self.start_date
      debug "TRUE!!!!!"
      true
    else
      debug "FALSE !!!!!"
      self.errors.add(:start_date, "Invalid start date. Please choose a date between #{date_down.strftime('%B %d, %Y')} and #{date_up.strftime('%B %d, %Y')}")
      false
    end
    true
  end
end
