class ActionsController < ApplicationController
	before_action :get_actions, only: [:index,:show,:me]
	def index
		count_pageview(0)
		add_timeline
	end
	def show
		if current_user.id != params[:id].to_i
			@actions = @actions.where("who = #{params[:id]}")
			@user = User.find(params[:id])
			count_pageview(1)
			add_timeline
		else
			redirect_to :action => 'me', :act_time => params[:act_time]
		end
	end
	def me
		@actions = @actions.where("who = #{current_user.id}")
		count_pageview(2)
		add_timeline
	end
	def create
		if action_params
			who = User.find(params[:who].first)
			author = User.find(params[:author])
			#１対多で結びついてるやつは１のレコードごと引っこ抜かなエラー出る
			@action = Action.create(:who => who,:act_time => (DateTime.parse(params[:date]+" "+params[:time])-9.hour),:where => params[:where],:what => params[:what],:author => author)
			if @action.new_record?#保存に失敗するとtrue
				render nothing: true
			else
				Activity.plus_exp(current_user.id,5,"ほめました")
				action_id = @action.id
				params[:who].each do |who|
					ActionWho.create(:action_id => action_id,:user_id => who)
					Approve.data_create(current_user.id,who,1)
					Activity.plus_exp(who,3,"褒められました")
				end
				@actions = Action.where("id = #{action_id}")
				respond_to do |format|
					format.html { render :partial =>'timeline' }
				end
			end
		end
	end

	private
		def action_params
			params.permit({:who => []},:date,:time,:where,:what,:author)
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
		def get_actions
			@actions = Action.joins(:who).where("users.group_id = #{current_user.group_id}").order("act_time desc")
		end
		def add_timeline
			if(params[:act_time])#lazyload用
				@actions = @actions.where("act_time <= '#{Time.parse(params[:act_time])}'").order("act_time desc").limit(10).offset(1)
				if @actions.present?
					respond_to do |format|
						format.html { render :partial =>'timeline' }
					end
				else
					render nothing: true
				end
			elsif request.xml_http_request?#pjax用
				@actions = @actions.order("act_time desc").limit(10)
				respond_to do |format|
					format.html { render :layout => false}
				end
			else
				@actions = @actions.order("act_time desc").limit(10)
			end
		end

end