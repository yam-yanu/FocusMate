class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :login_check, :unless => :my_status?
  before_filter :get_user_list
  before_filter :prize_mate
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
		@user_list = User.all
	end
end