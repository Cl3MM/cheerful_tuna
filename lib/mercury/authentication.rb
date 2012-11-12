module Mercury
  module Authentication

    def can_edit?
      true # check here to see if the user is logged in/has access
      current_user.is_admin?
    end

  end
end
