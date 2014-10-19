module ApplicationHelper
	# 今週褒めた回数
	def approve_count(user_id)
		beginning_of_week = Time.now.in_time_zone('Tokyo').beginning_of_week.utc.to_s(:db)
		approve_count = Approve.where("approve_user_id = #{user_id} and created_at >= datetime('#{beginning_of_week}')").count
		return approve_count
	end

	# 今週褒められた回数
	def approved_count(user_id)
		beginning_of_week = Time.now.in_time_zone('Tokyo').beginning_of_week.utc.to_s(:db)
		approve_count = Approve.where("approved_user_id = #{user_id} and created_at >= datetime('#{beginning_of_week}')").count
		return approve_count
	end

	# 経験値関連の数値
	def required_exp(user_id)
		user = User.find_by(:id => user_id)
		present_level = user.level
		@exp = {}
		# 現在の経験値
		@exp["present"] = user.exp - present_level.required_exp
		# レベルアップに必要な経験値
		@exp["next"] = Level.find_by(:level => (present_level.level + 1)).required_exp - present_level.required_exp
		#経験値メーター
		@exp["gauge"] = (@exp["present"].to_f / @exp["next"].to_f)*100
		#残り経験値
		@exp["require"] = @exp["next"] - @exp["present"]
		return @exp
	end

end