#! /usr/bin/env ruby

require 'aws-sdk-core'
require 'net/http'

unless ARGV.size > 1
  puts "Usage: #{$PROGRAM_NAME} [AUTO_SCALING_GROUP_NAME] [DIFFERENCE_TIME] \
[DESCRIPTION](Launching or Terminating)"
  exit 1
end

autoscaling_group_name = ARGV[0]
diff_time = ARGV[1]
description = ARGV[2] || 'Launching'
scale_instances = 0

def asg
  metadata_endpoint = 'http://169.254.169.254/latest/meta-data/'
  local_hostname = Net::HTTP.get(
    URI.parse(metadata_endpoint + '/local-hostname')
  )
  region = local_hostname.split('.')[1]
  @asg = Aws::AutoScaling::Client.new(region: region)
end

def describe_activities(asg_group_name)
  asg.describe_scaling_activities(
    auto_scaling_group_name: asg_group_name.to_s
  )
end

asg.describe_auto_scaling_groups.auto_scaling_groups.each do |asg_group|
  next unless asg_group.auto_scaling_group_name =~ /^#{autoscaling_group_name}/
  describe_activities(asg_group.auto_scaling_group_name).each do |activities|
    activities.activities.each do |activity|
      next if Time.parse(activity.start_time.inspect) \
        < (Time.now - diff_time.to_i).gmtime
      scale_instances += 1 if activity.description.include? description
    end
  end
end

puts scale_instances
