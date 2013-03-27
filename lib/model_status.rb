module ModelStatus
  extend ActiveSupport::Concern


  included do
    Rails.logger.debug "+" * 120
    Rails.logger.debug "Including ModelStatus module..."

    #define_singleton_method "#{self.name.downcase}_status" do
      #if const_defined?( "#{self.name.pluralize}_status".upcase )
        #eval "#{self.name.pluralize}_status".upcase
      #else
        #{ nothing: :there }
      #end
    #end

    membership_status.keys.each do |s|
      define_method "#{s}!" do
        self.update_attribute( :status, s.to_sym)
      end

      define_method "#{s}?" do
        status.to_sym == s
      end
      alias_method(:suspend!, :suspended!) if method_defined?(:suspended!)
    end if self.column_names.include?("status")
  end

  def membership_status
    if const_defined?( "#{self.name.pluralize}_status".upcase )
      eval "#{self.name.pluralize}_status".upcase
    else
      { }
    end
  end
  module_function :membership_status

  module ClassMethods

    def membership_status
      if const_defined?( "#{self.name.pluralize}_status".upcase )
        eval "#{self.name.pluralize}_status".upcase
      else
        { nothing: :there }
      end
    end

  end

end
