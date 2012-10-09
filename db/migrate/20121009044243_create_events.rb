class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.datetime :from, :default => Datetime.current
      t.datetime :to
      t.string :position
      t.string :desc
      t.integer :color, :default => 0
      t.integer :privacy, :default => 0
      t.boolean :work
      t.integer :user_id

      t.timestamps
    end
  end
end
