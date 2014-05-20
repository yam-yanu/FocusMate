class LoginController < ApplicationController
	def show
		if current_user
			redirect_to :controller => 'actions', :action => 'index'
		else
			render :action => "show", :layout => false
		end
	end
end
