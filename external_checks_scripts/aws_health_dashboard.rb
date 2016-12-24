#!/usr/bin/env ruby

require 'nokogiri'
require 'net/http'

if ARGV.empty?
  puts "Usage: #{$PROGRAM_NAME} [AWS Service] [AWS Region](option)"
  exit 1
end

svc = ARGV[0]
metadata_endpoint = 'http://169.254.169.254/latest/meta-data/'
local_hostname = Net::HTTP.get(URI.parse(metadata_endpoint + '/local-hostname'))
region = ARGV[1] || local_hostname.split('.')[1]

url = "http://status.aws.amazon.com/rss/#{svc}-#{region}.rss"

begin
  xml_data = Net::HTTP.get_response(URI.parse(url)).body
  xml_doc = Nokogiri::XML.parse(xml_data)
  rss = xml_doc.xpath('rss')
  if rss.size.zero?
    puts "specified an incorrect url? (#{url})"
    exit 1
  end

  item = xml_doc.xpath('rss/channel/item')
  if item.count.zero?
    puts 4
    exit
  end

  latest_status = item.xpath('title').first.text
  case latest_status
  when /^service is operating normally/i, /Informational message/i
    puts 0
  when /^performance issues/i
    puts 1
  when /^service disruption/i
    puts 2
  else
    puts 3
  end
rescue => e
  puts e
  exit 1
end
