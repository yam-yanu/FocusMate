class ApplicationController < ActionController::Base
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :exception
	before_action :login_check, :unless => :my_status?
	before_action :get_user_list
	before_action :prize_mate
	before_action :mobile_check
	before_action :current_location_check

private
	def login_check
		unless current_user
			redirect_to :controller => 'login', :action => 'show'
		end
	end
	def my_status?
		self.controller_name == 'login' || request.path_info.match(/^\/users/)
	end

	def prize_mate
		@action = Action.new
	end
	def get_user_list
		@user_list = User.all.order("updated_at desc");
	end
	def mobile_check
		ua = request.env["HTTP_USER_AGENT"]
		if(ua.include?('Mobile') || ua.include?('Android'))
			@isMobile = true
		else
			@isMobile = false
		end
	end
	def current_location_check
		if self.controller_name == "actions"
			if self.action_name == "index"# || self.action_name == "show"
				@current_location = 0
			elsif self.action_name == "me"
				@current_location = 1
			else
				@current_location = false
			end
		else
			@current_location = false
		end
	end
end