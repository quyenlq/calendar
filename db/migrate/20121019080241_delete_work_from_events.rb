class DeleteWorkFromEvents < ActiveRecord::Migration
  def up
  	remove_column :events, :work
  end

  def down
  	add_column :events, :work, :boolean
  end
end
