#! /usr/bin/env ruby

require 'aws-sdk'
require 'net/http'

if ARGV.size < 3
  puts "Usage: #{$PROGRAM_NAME} [LOG_GROUP_NAME] \
[FILTER_PATTERN] [DIFFERENCE_TIME]"
  exit 1
end

metadata_endpoint = 'http://169.254.169.254/latest/meta-data/'
local_hostname = Net::HTTP.get(URI.parse(metadata_endpoint + '/local-hostname'))
region = local_hostname.split('.')[1]
log_group_name = ARGV[0]
filter_pattern = ARGV[1]
diff_time = ARGV[2]
now = Time.now.to_i

begin
  cloudwatchlogs = Aws::CloudWatchLogs::Client.new(region: region)

  logs = cloudwatchlogs.filter_log_events(
    log_group_name:  log_group_name,
    start_time: (now - diff_time.to_i) * 1000,
    end_time: now * 1000,
    filter_pattern: filter_pattern,
    interleaved: true
  )

  last_event = logs.events.sort_by { |log| log[:timestamp] }.last
  if last_event.nil?
    puts 'no filtering'
  else
    puts last_event.message.to_s
  end
rescue => e
  puts e
  exit 1
end
