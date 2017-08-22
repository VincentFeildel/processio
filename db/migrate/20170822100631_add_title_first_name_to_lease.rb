class AddTitleFirstNameToLease < ActiveRecord::Migration[5.1]
  def change
    add_column :leases, :tenant_first_name, :string
    add_column :leases, :tenant_gender, :string
  end
end
