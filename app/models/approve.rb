class Approve < ActiveRecord::Base
	# type
	# メンバーの行動を記述 => 0
	# 記述に対してコメント => 1
	# すごいボタン => 2
	def self.data_create(approve,approved,type)
		Approve.create(:approve_user_id => approve,:approved_user_id => approved,:approve_type => type)
	end
end
