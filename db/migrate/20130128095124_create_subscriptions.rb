class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      if Rails.env.test?
        t.integer :owner_id
        t.string  :owner_type,  limit:      80
      else
        t.integer :owner_id,    null:       false
        t.string  :owner_type,  null:       false,  limit: 80
      end
      t.boolean   :current,     default:    false
      t.boolean   :paid,        default:    false
      t.date      :start_date
      t.date      :end_date
      t.decimal   :cost,        precision:  15,     scale: 3, default: 0
      t.string    :status

      t.timestamps
    end
    add_index     :subscriptions, [ :owner_id, :owner_type ]
    add_index     :subscriptions, :start_date
    add_index     :subscriptions, :end_date
    add_index     :subscriptions, :status
    add_index     :subscriptions, :current
    add_index     :subscriptions, [ :owner_id, :start_date, :end_date ], unique: true

    Member.all.each do |m|
      unless m.subscriptions.any?
        attrs = {
          start_date: m.start_date,
          end_date:   m.end_date,
          paid:       true,
          current:    true
        }
        fee = m.category_price =~ /\d/ ? m.category_price.chop.to_i : 0
        attrs.store( :cost, fee )

        Rails.logger.debug "member: #id: #{m.id.to_s.ljust(4)} \nattrs: #{attrs.map { |k,v| " - #{k}: #{v}" }.join("\n")}\n\n"
        puts "member: #id: #{m.id.to_s.ljust(4)} | name: #{m.company}\nattrs: #{attrs.map { |k,v| " - #{k}: #{v}" }.join("\n")}\n\n"
        m.subscriptions.create!( attrs )
      end
    end
  end
end
