class ActionWho < ActiveRecord::Base
	belongs_to :action
	belongs_to :user
end
