class AddAllDayToEvents < ActiveRecord::Migration
  def change
    add_column :events, :allDay, :boolean
  end
end
