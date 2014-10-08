require 'clockwork'
require File.expand_path('../../boot', __FILE__)
require File.expand_path('../../environment', __FILE__)
require File.expand_path('../npc_approve', __FILE__)
module Clockwork
    handler do |job|
        job.call
    end
    #every(1.minutes,NpcApprove.new)
    every(1.minutes,NpcApprove.new, :at => 'Sunday 16:01')
    # every(1.week,NpcApprove.new, :at => 'Sunday 15:01')
end