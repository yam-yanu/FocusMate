class MailMagagine
  def call
    send_to_all
  end
  def send_to_all
    users = User.joins(:group).where("groups.game_flag = 1")
    # users = User.where("id = 1")
    users.each do |user|
      if user.mail_count == 0
        mail = FirstMail.new(user)
      elsif user.mail_count == 1
        mail = SecondMail.new(user)
      elsif user.mail_count == 2
        mail = ThirdMail.new(user)
      elsif user.mail_count == 3
        mail = FourthMail.new(user)
      else
        mail = DefaultMail.new(user)
      end
      mail.send
    end
  end

  class Mail
    def initialize(user)
      # @user = user
      @user = user
      @subject = ""
      @body = "こんばんは\nFocusMateです．\n\n"
    end
    def send
      NoticeMailer.sendmail_confirm(@user.email,@subject,@body).deliver
    end
    def count_up
      @user.update_attribute(:mail_count,(@user.mail_count + 1))
    end
  end
  class FirstMail < Mail
    def initialize(user)
      super(user)
      @subject = "もう使ってみましたか?"
      @body << @user.name
      @body << "さんはもうメイトを\n褒めてみましたか？\n\n"
      @body << "FocusMateで行動して\n新しい称号をゲットしてみましょう！\n\n"
      @body << "http://49.212.200.39:3000\n\n"
      @body << "p.sスマホからアクセスしてうまいこと操作すると\nFocusMateがアプリっぽくなります．"
      count_up
    end
  end
  class SecondMail < Mail
    def initialize(user)
      super(user)
      @subject = "称号「" + @user.level.degree + "」をゲットしています"
      @body << "FocusMateが始まってけっこう時間が経ちましたね．\n"
      @body << "メイトを褒めていてくれたら幸いです．\n\n"
      @body << "メイトの良い部分を発見するきっかけになれば良いですね．\n\n"
      @body << "http://49.212.200.39:3000\n\n"
      @body << "p.s思ったよりレベルを上げてくれている方もいらっしゃってうれしいです．\n"
      @body << "なので最初はレベル10までしかなかったのですがレベルを追加しました．\n"
      @body << "ちなみに高いレベルほど変な称号になります．"
      count_up
    end
  end
  class ThirdMail < Mail
    def initialize(user)
      super(user)
      @subject = "時間が経つのは早いですね．"
      @body << @user.name
      @body << "さんがFocusMateを始めてからかなり経ちましたね．\n"
      @body << "メイトを褒めるって意外と難しいですよね．\n"
      @body << "できるだけすぐに褒めるのがコツだそうです．\n\n"
      @body << "http://49.212.200.39:3000\n\n"
      @body << "p.s褒めることは自分の洞察力や観察力アップにも繋がるそうです．"
      count_up
    end
  end
  class FourthMail < Mail
    def initialize(user)
      super(user)
      @subject = @user.name + "さんは現在，レベル" + @user.level.level.to_s + "です"
      @body << "実はこのメールが届いている方はレベル機能がある方だけ\n"
      @body << "ということに気づかれているでしょうか．\n\n"
      @body << "ちなみにFocusMateでは出来ませんが\n第三者を通して褒めると褒めの効果が高くなるそうですよ．\n"
      @body << "http://49.212.200.39:3000\n\n"
      @body << "p.s実はFocusMateはgithubにソースを公開しています．\n"
      @body << "汚いソースを直したくなる人にとってはたまらないソースとなっています．"
      count_up
    end
  end
  class DefaultMail < Mail
    def initialize(user)
      super(user)
    end
    def send
    end
  end
end