class Notification < ActiveRecord::Base
	def self.send_lvup(user_id)
		tweet = "#{user_id}さんのレベルが上がった"
		dummy = "aaa"
		WebsocketRails[dummy].trigger "create", tweet
		logger.debug(tweet)
	end
end
