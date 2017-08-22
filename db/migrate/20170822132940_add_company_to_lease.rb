class AddCompanyToLease < ActiveRecord::Migration[5.1]
  def change
    add_column :leases, :tenant_company, :string
  end
end
