class ActionsController < ApplicationController
	def index
		@actions = Action.order("act_time desc")
		@comments = Comment.all
		@action = Action.new
		count_pageview(0)
	end
	def show
		if current_user.id != params[:id].to_i
			@actions = Action.where("who = #{params[:id]}").order("act_time desc")
			@user = User.find(params[:id])
			count_pageview(1)
		else
			redirect_to :action => 'me'
		end
	end
	def me
		@actions = Action.where("who = #{current_user.id}").order("act_time desc")
		count_pageview(2)
	end
	def create
		if action_params
			# @action = Action.new(:who => params[:who],:act_time => DateTime.new(params[:year],params[:month],params[:day],params[:hour],params[:minnutes]),:where => params[:where],:where => params[:what])
			render nothing: true
			user = User.find(params[:who])
			author = User.find(params[:author])
			datetime = DateTime.new(params[:year].to_i,params[:month].to_i,params[:day].to_i,params[:hour].to_i,params[:minutes].to_i,0) - 9.hour
			# datetime = DateTime.new(2014,8,31,17,10,00)
			# datetime = Time.now
			@action = Action.new(:who => user,:act_time => datetime,:where => params[:where],:what => params[:what],:author => author)
			@action.save
		end
	end

	private
		def action_params
			params.permit(:who,:year,:month,:day,:hour,:minutes,:where,:what,:author)
		end

		def count_pageview(request_page)
			ua = request.env["HTTP_USER_AGENT"]
			if(ua.include?('Mobile') || ua.include?('Android'))
				user_agent = 1
			else
				user_agent = 0
			end
			Pageview.create(:user_id => current_user.id,:request_page => request_page,:user_agent => user_agent)
		end
end