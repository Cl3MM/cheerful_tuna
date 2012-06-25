class StatController < ApplicationController
  def index
    @contacts = Contact.limit(2)
  end

  def user
  end

  def contact
  end
end
