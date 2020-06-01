set :output, 'log/cron_log.log'

every 1.minute do
  runner 'RefreshQueriesJob.perform_now'
end
