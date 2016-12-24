#! /usr/bin/env ruby

require 'aws-sdk-v1'
require 'net/http'

if ARGV.size < 3
  puts "Usage: #{$PROGRAM_NAME} [DATABASE_IDENTIFIER] [DIFFERENCE_TIME(sec)] \
[EVENT_CATEGORY(creation/configuration change/backup/failover/availability/\
etc...)]"
  exit 1
end

source_id = ARGV[0]
diff_time = ARGV[1]
event_cat = ARGV[2]
metadata_endpoint = 'http://169.254.169.254/latest/meta-data/'
local_hostname = Net::HTTP.get(URI.parse(metadata_endpoint + '/local-hostname'))
region = local_hostname.split('.')[1]

rds = AWS::RDS::Client.new(region: region)

events = rds.describe_events(
  start_time: (Time.now - diff_time.to_i).iso8601,
  end_time: Time.now.iso8601,
  source_type: 'db-instance',
  event_categories: [event_cat],
  source_identifier: source_id
)[:events]

last_event = events.sort_by { |event| event[:date] }.last
if last_event.nil?
  puts 'Event not found'
else
  puts last_event[:message]
end
