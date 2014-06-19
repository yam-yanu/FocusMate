class CommentsController < ApplicationController
	def add_comment
		@comment = Comment.new(comment_params)
		if @comment.save
			respond_to do |format|
				format.html { render :partial =>'one_comment' }
			end
		else
			render nothing: true
		end
	end

	private
		def comment_params
			params.permit(:user_id,:action_id,:comment)
		end
end
