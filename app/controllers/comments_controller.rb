class CommentsController < ApplicationController
	def add_comment
		@comment = Comment.new(comment_params)
		ActionWho.where("action_id = #{params[:action_id]}").find_each do |who|
			Approve.data_create(current_user.id,who.user_id,2)
			Activity.plus_exp(current_user.id,3,"コメントしました")
		end
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
