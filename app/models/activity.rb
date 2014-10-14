class Activity < ActiveRecord::Base
    def plus_exp(user_id,exp,content)
        # アクティビティを作成
        Activity.create(:user_id => user_id,:exp => exp,:content => content)
        # 経験値を足す
        user = User.where("id = #{user_id}").update("exp = exp + #{exp}")
        # レベルが上がるようであればnotificationも作成
        require_exp = Level.where("level = (#{user.level} + 1)")
        if user.exp > require_exp
            user.update("level = level + 1")
            Notification.create(":user_id => #{user_id}")
        end
    end
end
