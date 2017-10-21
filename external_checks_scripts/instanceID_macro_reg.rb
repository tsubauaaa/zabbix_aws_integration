#! /usr/bin/env ruby

#./instanceID_macro_reg.rb {HOST.NAME} {ITEM.VALUE1}

require "zabbixapi"
require 'yaml'

unless ARGV.size == 3
  puts "Usage: #{$0} [AGENT_HOST_NAME] [FETCH_INSTANCE_ID_VALUE]"
  exit 1
end

config = YAML.load(File.read(".zabbix/config.yml"))
zabbix_url = config['URL']
zabbix_id = config['USER']
zabbix_passwd = config['PASSWORD']

host_name = ARGV[0]
macro_value = ARGV[1]

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
