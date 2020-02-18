class RefreshQueriesJob < ApplicationJob
  queue_as :default

  def perform
    Query.refresh_queries
  end
end
