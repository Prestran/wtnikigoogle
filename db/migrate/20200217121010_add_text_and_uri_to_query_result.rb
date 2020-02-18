class AddTextAndUriToQueryResult < ActiveRecord::Migration[5.2]
  def change
    add_column :query_results, :text, :text
    add_column :query_results, :uri, :text
  end
end
