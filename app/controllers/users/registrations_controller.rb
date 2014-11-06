class Users::RegistrationsController < Devise::RegistrationsController
  skip_before_filter :verify_authenticity_token, only: [:create]
  layout false

  def build_resource(hash=nil)
    hash[:uid] = User.create_unique_string
    hash[:exp] = 0
    hash[:level] = Level.find_by(level: 1)
    hash[:group_id] = 0
    hash[:image] = "/assets/no_image.gif"
    super
  end

  def create
    build_resource(user_params)
    if resource.save
      resource.remember_me = true
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_up(resource_name, resource)
        return render :json => {:result => "sign_up"}
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        expire_session_data_after_sign_in!
        return render :json => {:result => "sign_up"}
      end
    else
      clean_up_passwords resource
      return render :json => {:result => resource.errors.full_messages}
    end
  end

  def sign_up(resource_name, resource)
    sign_in(resource_name, resource)
  end

  def new
#     render nothing: true
    super
  end

  def user_params
    params.require(:user).permit(:name,:email,:password,:password_confirmation)
  end

end