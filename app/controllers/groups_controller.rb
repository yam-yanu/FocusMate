class GroupsController < ApplicationController
	def index
		@groups = Group.all.limit(10);
	end

	def create
		@group = Group.new(group_params)
		if @group.save
			User.where("id = '#{current_user.id}'").update_all("group_id = '#{@group.id}'")
			@group.update_attribute(:game_flag,0)
		end
		redirect_to :controller => 'actions', :action => 'index'
	end

	def change_group
		if current_user.group_id != 0
			render :js => "alert('グループに入り直すことは出来ません.');"
			destroy_session_group_id
			return
		end
		if session[:group_id]
			User.where("id = '#{current_user.id}'").update_all("group_id = '#{params[:group_id]}'")
			render :js => "$(location).attr('href', '/actions');show_loading();"
			destroy_session_group_id
		elsif params[:group_id] && params[:password]
			password = Group.where("id = '#{params[:group_id]}'")
			if password[0].password == params[:password]
				User.where("id = '#{current_user.id}'").update_all("group_id = '#{params[:group_id]}'")
				render :js => "$(location).attr('href', '/actions');show_loading();"
			else
				render :js => "alert('合言葉が違うようです.')"
			end
		else
			render nothing: true
		end
	end

	def activate_gamification
		Group.where("id = #{params[:group_id]}").update_all("game_flag = 1")
		redirect_to :controller => 'actions', :action => 'index'
	end

	private
		def group_params
			params.permit(:name,:password,:detail)
		end
end
