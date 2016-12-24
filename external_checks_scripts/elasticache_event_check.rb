#! /usr/bin/env ruby

require 'aws-sdk'
require 'net/http'

if ARGV.size < 2
  puts "Usage: #{$PROGRAM_NAME} [CACHECLUSTER_IDENTIFIER] [DIFFERENCE_TIME(minute)]"
  exit 1
end

source_id = ARGV[0]
diff_time = ARGV[1]
metadata_endpoint = 'http://169.254.169.254/latest/meta-data/'
local_hostname = Net::HTTP.get(URI.parse(metadata_endpoint + '/local-hostname'))
region = local_hostname.split('.')[1]

elasticache = Aws::ElastiCache::Client.new(region: region)

events = elasticache.describe_events(
  source_type: 'cache-cluster',
  source_identifier: source_id,
  duration: diff_time
)[:events]

last_event = events.sort_by { |event| event[:date] }.last
if last_event.nil?
  puts 'Event not found'
else
  puts last_event[:message]
end
