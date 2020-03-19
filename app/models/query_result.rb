class QueryResult < ApplicationRecord
  belongs_to :query

  validates_presence_of :text, :uri
end
