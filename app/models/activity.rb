class Activity < ActiveRecord::Base
    belongs_to :user

    def self.plus_exp(user_id,exp,content)
        # アクティビティを作成
        Activity.create(:user_id => user_id,:exp => exp,:content => content)
        # 経験値を足す
        user = User.where("id = #{user_id}").update_all("exp = exp + #{exp}")
        # レベルが上がるかチェック
        Level.check(user)
    end
end