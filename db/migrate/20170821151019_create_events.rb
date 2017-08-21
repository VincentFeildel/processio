class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.references :lease, foreign_key: true
      t.datetime :start_date
      t.datetime :urgent_date
      t.datetime :end_date
      t.string :type
      t.string :status
      t.string :emergency_level
      t.boolean :to_do

      t.timestamps
    end
  end
end
