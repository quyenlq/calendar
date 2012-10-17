class ChangeDataTypeForEventsColor < ActiveRecord::Migration
  def up
  	change_table :events do |t|
      t.change :color, :string
    end
  end

  def down
  	change_table :events do |t|
      t.change :color, :integer
    end
  end
end
