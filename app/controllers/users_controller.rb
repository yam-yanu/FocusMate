class UsersController < ApplicationController
	def update_users
		@user_list = User.find_by_sql("select id,updated_at from users")
		# @user_list.each do |user|
		# 	user.updated_at = Time.now - user.updated_at
		# end
		respond_to do |format|
			format.html { render :partial =>'user_list' }
			#format.json { render :json => @user_list }
		end
	end
end
