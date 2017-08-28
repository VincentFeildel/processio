class CreateIndices < ActiveRecord::Migration[5.1]
  def change
    create_table :indices do |t|
      t.datetime :app_date
      t.float :indice

      t.timestamps
    end
  end
end
