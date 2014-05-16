class LoginController < ApplicationController
	def show
		if current_user
			redirect_to :controller => 'action', action => 'index'
		end
		render :action => "show", :layout => false
	end
end
