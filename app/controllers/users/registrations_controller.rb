class Users::RegistrationsController < Devise::RegistrationsController

  def build_resource(hash=nil)
    hash[:uid] = User.create_unique_string
    super
  end

  # GET /resource/sign_up
  def new
    puts 'hogeho'
    build_resource({})
    # puts self.resource
    respond_with self.resource
  end

end