class AddUserIdToEventSets < ActiveRecord::Migration
  def change
    add_column :event_sets, :user_id, :integer
  end
end
