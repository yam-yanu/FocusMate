class RenameWhenToActions < ActiveRecord::Migration
  def self.up
    rename_column :actions, :when, :act_time
  end
  def self.down
    rename_column :actions, :act_time, :when
  end
end
