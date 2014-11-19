class Users::PasswordsController < Devise::PasswordsController
  layout false
  def update
    super { |resource| resource.remember_me = true }
  end
end