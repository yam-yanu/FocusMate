class Level < ActiveRecord::Base
	has_many :users

	def self.check(user)
		user = User.find_by id: user
		#ユーザーのレベルが最大なら何もしない
		return if user.level.level >= Level.maximum("level")
		#レベルアップできるかチェックする
		required_exp = (Level.find_by level: (user.level.level + 1)).required_exp
		if user.exp >= required_exp
			User.where("id = #{user.id}").update_all("level = level + 1")
			Notification.create(:user_id => user.id,:level =>user.level.level,:read_flag => 0)
			Activity.plus_exp(user.id,0,"レベルアップしました")
			Level.check(user.id)
		end
	end
end
