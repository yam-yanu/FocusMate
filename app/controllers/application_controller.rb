class ApplicationController < ActionController::Base
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :null_session
	before_filter :configure_permitted_parameters, if: :devise_controller?
	before_action :invited_check
	before_action :login_check, :unless => :my_status?
	before_action :get_user_list
	before_action :prize_mate
	before_action :mobile_check
	before_action :current_location_check
	before_action :update_logined_at
	before_action :get_activity_list
	before_action :get_js_params

def destroy_session_group_id
	session[:group_id] = nil
end

private
	def invited_check #招待URLから来た場合ログイン処理を挟む場合があるのでいったんセッションにgroup_idを保持,ログインしていた場合のために@group_inviteも用意
		if session[:group_id]
			@group_invite = Group.where("id = #{session[:group_id]}").first
		elsif params[:group_id] && params[:password] && request.get?
			if @group_invite == Group.where("id = #{params[:group_id]} and password = '#{params[:password]}'").first
				session[:group_id] = params[:group_id]
			end
		end
		#既にグループに所属しているときは招待を取り消す
		if current_user
			if current_user.group_id != 0 && session[:group_id]# && session[:password]
				destroy_session_group_id
			end
		end
	end
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
		if current_user
			@user_list = User.where("group_id = #{current_user.group_id}").order("updated_at desc")
		end
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
	def update_logined_at
		if current_user
			user = User.find_by id: current_user.id
			if Time.now.in_time_zone('Tokyo').beginning_of_day - user.updated_at.in_time_zone('Tokyo').beginning_of_day > 0
				Activity.plus_exp(current_user.id,1,"ログインしました")
			end
			User.where("id = '#{current_user.id}'").update_all("updated_at = '#{Time.now}'")
		end
	end

	def get_activity_list
		if current_user
			@activities = Activity.joins("LEFT JOIN users ON activities.user_id = users.id").where("group_id = #{current_user.group_id}").order("created_at desc").limit(10)
		end
	end

	def get_js_params
		if current_user
			gon.current_user = current_user
		end
	end

protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :name
  end
end