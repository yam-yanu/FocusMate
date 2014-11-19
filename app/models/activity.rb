class Activity < ActiveRecord::Base
	belongs_to :user

	def self.plus_exp(user_id,exp,content)
		# アクティビティを作成
		Activity.create(:user => (User.find_by :id => user_id),:exp => exp,:content => content)
		# 経験値を足す
		user = User.where("id = #{user_id}").update_all("exp = exp + #{exp}")
		data = {}
		data["exp"] = ApplicationController.helpers.required_exp(user_id)
		WebsocketRails[user_id].trigger "plus_exp", data
		# レベルが上がるかチェック
		Level.check(user_id)
	end
end