require 'clockwork'
require File.expand_path('../../boot', __FILE__)
require File.expand_path('../../environment', __FILE__)
require File.expand_path('../npc_approve', __FILE__)
require File.expand_path('../mail_magagine', __FILE__)
module Clockwork
    handler do |job|
        job.call
    end
    #every(1.minutes,NpcApprove.new)
    every(1.minutes,NpcApprove.new, :at => 'mon 00:01')
    every(1.minutes,MailMagagine.new, :at => 'wed 18:00')
end