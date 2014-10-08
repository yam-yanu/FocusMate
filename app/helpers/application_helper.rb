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
end
