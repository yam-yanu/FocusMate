class Notification < ActiveRecord::Base
	def self.send_lvup(user_id)
		tweet = "#{user_id}さんのレベルが上がった"
		WebsocketRails[user_id].trigger "create", tweet
	end
end