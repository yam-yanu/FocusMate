class NpcApprove
  def call
    approve_prize
    approved_prize
  end

  def approve_prize
    prev_week_time = Time.now.in_time_zone('Tokyo').prev_week.utc.to_s(:db)
    users = Approve.find_by_sql(
        "select * from
        (
            select approve_user_id as id,count(a.id) as count from approves as a
            left join users as u on a.id = u.id
            left join groups as g on u.group_id = g.id
            where a.created_at >= datetime('#{prev_week_time}') and
            g.game_flag = 1
            group by a.approve_user_id
        )as approve where approve.count >= 2")
    users.each do |user|
      action = Action.create(:who => User.find(user.id),:act_time => Time.now,:where => "FocusMateで",:what => "先週、よく褒めました",:author => User.first,:action_type => 1)
      if !action.new_record?#保存に失敗するとtrue
        ActionWho.create(:action_id => action.id,:user_id => user.id)
      end
    end
  end
  def approved_prize
    prev_week_time = Time.now.in_time_zone('Tokyo').prev_week.utc.to_s(:db)
    users = Approve.find_by_sql(
        "select * from
        (
            select approved_user_id as id,count(a.id) as count from approves as a
            left join users as u on a.id = u.id
            left join groups as g on u.group_id = g.id
            where a.created_at >= datetime('#{prev_week_time}') and
            g.game_flag = 1
            group by a.approved_user_id
        )as approve where approve.count >= 2")
    users.each do |user|
      action = Action.create(:who => User.find(user.id),:act_time => Time.now,:where => "FocusMateで",:what => "先週、よく褒められました",:author => User.first,:action_type => 1)
      if !action.new_record?#保存に失敗するとtrue
        ActionWho.create(:action_id => action.id,:user_id => user.id)
      end
    end
  end
end