class ActionsController < ApplicationController
	def index
		@actions = Action.order("act_time desc")
		@comments = Comment.all
		@action = Action.new
	end
	def show
		@actions = Action.where("who = #{params[:id]}").order("act_time desc")
		@user = User.find(params[:id])
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
end