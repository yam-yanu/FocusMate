class Action < ActiveRecord::Base
	belongs_to :who, :class_name => 'User', :foreign_key => 'who'
	belongs_to :author, :class_name => 'User', :foreign_key => 'author'
end
