class RenameTypeToApprove < ActiveRecord::Migration
	def up
		rename_column :approves, :type, :approve_type
	end
	def down
		rename_column :approves, :approve_type, :type
	end
end
