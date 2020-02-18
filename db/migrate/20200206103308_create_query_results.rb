class CreateQueryResults < ActiveRecord::Migration[5.2]
  def change
    create_table :query_results do |t|

      t.timestamps
    end
  end
end
