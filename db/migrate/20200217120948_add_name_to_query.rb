class AddNameToQuery < ActiveRecord::Migration[5.2]
  def change
    add_column :queries, :name, :text
  end
end
