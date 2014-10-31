class Level < ActiveRecord::Base
	has_many :users
	has_many :notifications

	def self.check(user = nil)
		return if !user
		user = User.find_by id: user
		#ユーザーのレベルが最大なら何もしない
		return if user.level.level >= Level.maximum("level")
		#レベルアップできるかチェックする
		next_level = Level.find_by level: (user.level.level + 1)
		required_exp = next_level.required_exp
		if user.exp >= required_exp
			# User.where("id = #{user.id}").update_all("level = level + 1")
			user.update_attribute(:level,next_level)
			notification = Notification.create(:user => user,:level =>next_level,:read_flag => 0)
			Notification.send_lvup(user.id,notification)
			Activity.plus_exp(user.id,0,"レベルアップしました")
			Level.check(user.id)
		end
	end
end