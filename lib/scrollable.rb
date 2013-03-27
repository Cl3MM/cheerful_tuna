module Scrollable

  extend ActiveSupport::Concern

  included do
  end

  def method_missing(meth, *args, &block)
    if meth.to_s =~ /^(previous|next)_?(\w*)$/
      action, attribute = $1, $2
      return run_previous_method(attribute, *args, &block)  if action =~ /previous/
      return run_next_method(attribute, *args, &block)      if action =~ /next/
      nil
    else
      super
    end
  end

  def run_next_method(attrs, *args, &block)
    #puts "Attrs: #{attrs}"
    #puts "Attrs: #{attrs}"
    if (not attrs.blank?) && (self.attribute_names.include?(attrs) )
      return self.class.where( [ "#{attrs} > ?", self[attrs] ] ).first
    else
      return self.class.where(["id > ?", self.id]).first
    end
  end

  def run_previous_method(attrs, *args, &block)
    if (not attrs.blank?) && (self.attribute_names.include?(attrs) )
      return self.class.where( [ "#{attrs} < ?", self[attrs] ] ).last
    else
      return self.class.where(["id < ?", self.id]).last
    end
  end

  module ClassMethods
  end

end

