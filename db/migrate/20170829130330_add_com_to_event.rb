class AddComToEvent < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :com_tenant, :string
    add_column :events, :com_owner, :string
  end
end
