class CreateEventSets < ActiveRecord::Migration
  def change
    create_table :event_sets do |t|
      t.integer, :frequency
      t.string, :period
      t.datetime, :from
      t.datetime, :to
      t.boolean, :allDay
      t.integer :weekdays

      t.timestamps
    end
  end
end
