class GreatsController < ApplicationController
	def index
		if(params[:action_id])
			@greats = Great.where("action_id = '#{params[:action_id]}'").order("created_at desc")
			if @greats.present?
				respond_to do |format|
					format.html { render :partial =>'index' }
				end
			else
				render nothing: true
			end
		else
			render nothing: true
		end
	end
	def add_great
		render nothing: true
		# if @great = Great.find(:all, :conditions => ["action_id = ? and user_id = ?", params[:action_id], params[:user_id]])
		# if Article.exists? "action_id = ? and user_id = ?", params[:action_id], params[:user_id]
		#if Great.exists? "action_id = ? and user_id = ?", params[:action_id], params[:user_id]
		if Great.exists?(:action_id => params[:action_id],:user_id => params[:user_id])
		else
			Great.create(great_params)
			ActionWho.where("action_id = #{params[:action_id]}").find_each do |who|
				Approve.data_create(current_user.id,who.user_id,3)
				Activity.plus_exp(current_user.id,1,"すごい！しました")
			end
		end
	end

	private
		def great_params
			params.permit(:user_id,:action_id)
		end
end
