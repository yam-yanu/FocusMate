class Notification < ActiveRecord::Base
	belongs_to :user
	belongs_to :level, :class_name => 'Level', :foreign_key => 'level'

	def self.send_lvup(user_id,notification)
		user = User.find_by :id => user_id
		data = {}
		view = ActionView::Base.new("app/views/layouts/").render(:partial=>"one_notification", :locals=>{:notification=>notification})
		data["message"] = view
		data["level"] = user.level.level
		data["degree"] = user.level.degree
		data["exp"] = ApplicationController.helpers.required_exp(user_id)
		WebsocketRails[user_id].trigger "lvup", data
	end
end