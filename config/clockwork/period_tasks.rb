class PeriodTasks
  def self.approve_prize
    npc = NpcApprove.new
    npc.approve_prize
  end

  def self.approved_prize
    npc = NpcApprove.new
    npc.approved_prize
  end

  def self.send_mail
    mail_magagine = MailMagagine.new
    mail_magagine.send_to_all
  end
end