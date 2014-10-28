class Users::RegistrationsController < Devise::RegistrationsController
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
    super { |resource| resource.remember_me = true }
    logger.debug("ああああああああああああああああああああ")
  end
  
  def new
#     render nothing: true
    super
  end

end