#! /usr/bin/env ruby

require 'aws-sdk-v1'

if ARGV.size < 8
  puts "Usage: #{$PROGRAM_NAME} [ACCESS_KEY] [SECRET_ACCESS_KEY] [REGION] [NAMESPACE] [METRIC_NAME] [DIMENTION_NAME] [DIMENTION_VALUE] [STATISTICS_TYPE](Average) [DIFFERENCE_TIME(sec)](600) [PERIOD(sec)](300)"
  exit 1
end

access_key = ARGV[0]
secret_key = ARGV[1]
region = ARGV[2]
namespace = ARGV[3]
metric_name = ARGV[4]
dime_name = ARGV[5]
dime_value = ARGV[6]
statistics_type = ARGV[7] || 'Average'
diff_time = ARGV[8] || '600'
period = ARGV[9] || '300'

AWS.config(
  access_key_id: access_key,
  secret_access_key: secret_key,
  region: region
)

metrics = AWS::CloudWatch::Metric.new(
  namespace,
  metric_name,
  dimensions: [
    { name: dime_name, value: dime_value }
  ]
)

stats = metrics.statistics(
  start_time: Time.now - diff_time.to_i,
  end_time: Time.now,
  statistics: [statistics_type],
  period: period.to_i
)

last_stats = stats.sort_by { |stat| stat[:timestamp] }.last
if last_stats.nil?
  puts nil
else
  puts last_stats[statistics_type.downcase.to_sym]
end
