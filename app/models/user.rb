class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :omniauthable, :recoverable,
         :registerable, :rememberable, :trackable, :validatable
  has_many :actions
  has_many :action_whos
  has_many :comments
  has_many :greats
  has_many :activities
  has_many :notifications
  belongs_to :group
  belongs_to :level, :class_name => 'Level', :foreign_key => 'level'

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    unless user
      user = User.create(name:     auth.extra.raw_info.name,
                         provider: auth.provider,
                         uid:      auth.uid,
                         email:    auth.info.email,
                         password: Devise.friendly_token[0,20],
                         image:    auth.info.image,
                         group_id: 0,
                         exp: 0,
                         level: Level.find_by(level: 1)
                        )
    end
    user
  end

  # def self.find_for_twitter_oauth(auth, signed_in_resource=nil)
  #   user = User.where(:provider => auth.provider, :uid => auth.uid).first
  #   unless user
  #     user = User.create(name:     auth.info.nickname,
  #                        provider: auth.provider,
  #                        uid:      auth.uid,
  #                        email:    User.create_unique_email,
  #                        password: Devise.friendly_token[0,20]
  #                       )
  #   end
  #   user
  # end

  # 通常サインアップ時のuid用、Twitter OAuth認証時のemail用にuuidな文字列を生成
  def self.create_unique_string
    SecureRandom.uuid
  end

  # # twitterではemailを取得できないので、適当に一意のemailを生成
  # def self.create_unique_email
  #   User.create_unique_string + "@example.com"
  # end
end
