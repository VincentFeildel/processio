class CreateLeases < ActiveRecord::Migration[5.1]
  def change
    create_table :leases do |t|
      t.references :user, foreign_key: true
      t.string :tenant_name
      t.string :tenant_address
      t.integer :num_lot
      t.string :owner_name
      t.string :owner_address
      t.string :owner_email
      t.integer :monthly_rent
      t.integer :rent_balance
      t.integer :overdue_days
      t.datetime :next_revision
      t.datetime :end_date
      t.string :nature

      t.timestamps
    end
  end
end
