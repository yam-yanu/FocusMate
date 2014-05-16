class CommentsController < ApplicationController
	def add_comment
		render nothing: true
		# if @great = Great.find(:all, :conditions => ["action_id = ? and user_id = ?", params[:action_id], params[:user_id]])
		# if Article.exists? "action_id = ? and user_id = ?", params[:action_id], params[:user_id]
		#if Great.exists? "action_id = ? and user_id = ?", params[:action_id], params[:user_id]
		if Comment.create(comment_params)
		# 	respond_to do |format|
		# 		format.js
		# 	end
		# else
		# 	render nothing: true
		end
	end

	private
		def comment_params
			params.permit(:user_id,:action_id,:comment)
		end
end
