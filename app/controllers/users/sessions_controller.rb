class Users::SessionsController < Devise::SessionsController
  layout false
  
	def new
		super
		#render nothing: true
	end

	def create
		super
		# render nothing: true
	end

end