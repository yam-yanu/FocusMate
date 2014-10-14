class MailController < ApplicationController
	def send_mail
		@mail = NoticeMailer.sendmail_confirm(params[:to_address],params[:subject],params[:body]).deliver
		render nothing: true
	end
end
