#! /usr/bin/env ruby

require 'zabbixapi'
require 'net/http'
require 'yaml'

unless ARGV.size == 1
  puts "Usage: #{$PROGRAM_NAME} [AGENT_HOST_NAME]"
  exit 1
end

config = YAML.safe_load(File.read('.zabbix/config.yml'))
zabbix_url = config['URL']
zabbix_id = config['USER']
zabbix_passwd = config['PASSWORD']

host_name = ARGV[0]
metadata_endpoint = 'http://169.254.169.254/latest/meta-data/'
macro_value = Net::HTTP.get(URI.parse(metadata_endpoint + '/instance-id'))

zbx = ZabbixApi.connect(
  url: zabbix_url,
  user: zabbix_id,
  password: zabbix_passwd
)

zbx.usermacros.create(
  hostid: zbx.hosts.get_id(host: host_name),
  macro: '{$INSTANCEID}',
  value: macro_value
)
