#!/usr/bin/env ruby
$LOAD_PATH.unshift("/opt/majordomus/majord/bin/lib") unless $LOAD_PATH.include?('lib')

require 'optparse'
#require 'docker'
require 'majordomus'

#Docker.url = 'tcp://localhost:6001'

#options = {}
#OptionParser.new do |opts|
#  opts.banner = "Usage: example.rb [options]"
#
#  opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
#    options[:verbose] = v
#  end
#end.parse!

#p options
#p ARGV

image = "#{ARGV[1]}/#{ARGV[2]}:latest"
cname = "#{ARGV[1]}.#{ARGV[2]}"

id = Majordomus::lookup_image_id image

meta = {
  "name" => cname,
  "image" => image,
  "image_id" => id,
  "container_id" => "",
  "env" => Majordomus::defined_params(id,['HOME','PATH']),
  "ports" => Majordomus::defined_ports(id),
  "volumes" => Majordomus::defined_volumes(id),
  "link" => []
}

Majordomus::container_metadata! cname, meta


