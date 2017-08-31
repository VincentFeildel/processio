class AddSumRentToBalanceDays < ActiveRecord::Migration[5.1]
  def change
    add_column :balance_days, :all_rents, :integer
  end
end
