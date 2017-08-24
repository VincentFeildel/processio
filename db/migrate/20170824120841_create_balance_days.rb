class CreateBalanceDays < ActiveRecord::Migration[5.1]
  def change
    create_table :balance_days do |t|
      t.datetime :day
      t.integer :balance

      t.timestamps
    end
  end
end
