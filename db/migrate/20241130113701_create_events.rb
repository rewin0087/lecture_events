class CreateEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :events do |t|
      t.datetime :start_datetime
      t.datetime :end_datetime
      t.integer :day_of_week

      t.timestamps
    end
  end
end
