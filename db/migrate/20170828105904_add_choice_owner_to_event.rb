class AddChoiceOwnerToEvent < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :choice_owner, :string
    add_column :events, :new_rent, :integer
  end
end
