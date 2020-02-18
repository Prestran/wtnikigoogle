class AddQueryIdToQueryResult < ActiveRecord::Migration[5.2]
  def change
    add_column :query_results, :query_id, :integer
  end
end
