class Notification < ActiveRecord::Base
	def send_lvup
		# lvup = Notification.where("user_id = #{current_user.id} and read_flag = 1")
		lvup = "れべるあがったー!"
		WebsocketRails[:streaming].trigger "lvup", lvup
		head :ok
	end
end
