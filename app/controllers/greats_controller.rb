class GreatsController < ApplicationController
	def add_great
		render nothing: true
		# if @great = Great.find(:all, :conditions => ["action_id = ? and user_id = ?", params[:action_id], params[:user_id]])
		# if Article.exists? "action_id = ? and user_id = ?", params[:action_id], params[:user_id]
		#if Great.exists? "action_id = ? and user_id = ?", params[:action_id], params[:user_id]
		if Great.exists?(:action_id => params[:action_id],:user_id => params[:user_id])
		else
			Great.create(great_params)
		end
	end

	private
		def great_params
			params.permit(:user_id,:action_id)
		end
end
