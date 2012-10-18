class AddEventSetIdToEvents < ActiveRecord::Migration
  def change
  	add_column :events, :event_set_id, :integer
  end
end
