class NoticeMailer < ActionMailer::Base
  default from: "FocusMate<sgj6aja8@kke.com>"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notice_mailer.sendmail_confirm.subject
  #
  def sendmail_confirm(to_address,subject,body)
    @body = body
    mail to: to_address, subject: subject
  end
end
