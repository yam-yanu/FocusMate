class NotificationsController < ApplicationController
	def destroy
		render nothing: true
		if notification_params
			Notification.where("id = #{params["id"]}").update_all("read_flag = 1")
		end
	end

	private
	def notification_params
		params.permit(:id)
	end
end
