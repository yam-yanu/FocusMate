class Users::PasswordsController < Devise::PasswordsController
  def update
    super { |resource| resource.remember_me = true }
  end
end