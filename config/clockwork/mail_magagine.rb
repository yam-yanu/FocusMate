class MailMagagine
  def call
    send_mail
  end

  def send_mail
    subject = "もう使ってみましたか?"
    users = User.joins(:group).where("groups.game_flag = 1")
    # users = User.where("id = 1")
    users.each do |user|
      body = "こんばんは\nFocusMateです．\n\n"
      body << select_body(user)
      address = user.email
      NoticeMailer.sendmail_confirm(address,subject,body).deliver
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

  def select_body(user)
    if user.mail_count == 0
      return first_mail(user)
    elsif user.mail_count == 1
      return second_mail(user)
    elsif user.mail_count == 2
      return third_mail(user)
    elsif user.mail_count == 4
      return fourth_mail(user)
    else
      return default_mail(user)
    end
  end

  def first_mail(user)
    body = ""
    body << user.name
    body << "さんはもうメイトを\n褒めてみましたか？\n\n"
    body << "FocusMateで行動して\n新しい称号をゲットしてみましょう！\n\n"
    body << "http://49.212.200.39:3000\n\n"
    body << "p.sスマホからアクセスしてうまいこと操作すると\nFocusMateがアプリっぽくなります．"
    count_up(user)
    body
  end
  def second_mail(user)
    body = ""
    body << "FocusMateが始まってけっこう時間が経ちましたね．\n"
    body << "メイトを褒めていてくれたら幸いです．\n\n"
    body << "メイトの良い部分を発見するきっかけになれば良いですね．\n\n"
    body << "http://49.212.200.39:3000\n\n"
    body << "p.s思ったよりレベルを上げてくれている方もいらっしゃってうれしいです．\n"
    body << "なので最初はレベル10までしかなかったのですがレベルを追加しました．\n"
    body << "ちなみに高いレベルほど変な称号になります．"
    count_up(user)
    body
  end
  def third_mail(user)
    body = ""
    body << user.name
    body << "さんがFocusMateを始めてからかなり経ちましたね．\n"
    body << "メイトを褒めるって意外と難しいですよね．\n"
    body << "できるだけすぐに褒めるのがコツだそうです．\n\n"
    body << "http://49.212.200.39:3000\n\n"
    body << "p.s褒めることは自分の洞察力や観察力アップにも繋がるそうです．"
    count_up(user)
    body
  end
  def fourth_mail(user)
    body = ""
    body << user.name
    body << "さん\n"
    body << "メイトを褒めるって意外と難しいですよね．\n"
    body << "できるだけすぐに褒めるのがコツだそうです．\n\n"
    body << "http://49.212.200.39:3000\n\n"
    body << "p.s褒めることは自分の洞察力や観察力アップにも繋がるそうです．"
    count_up(user)
    body
  end
  def dafault_mail(user)
    body = ""
    body << ""
    body
  end
  def count_up(user)
    user.update_attribute(:mail_count,(user.mail_count + 1))
  end
end