# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

every 1.days, at: '11:30 pm' do 
  runner "DailyReportingMailer.daily_new_comments_report.deliver"
end

every 1.hours do
  runner "TwitterBot.favorite_feed_selection!"
end

# Learn more: http://github.com/javan/whenever
