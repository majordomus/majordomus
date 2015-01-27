#!/usr/bin/env ruby
$LOAD_PATH.unshift("/opt/majordomus/majord/bin/lib") unless $LOAD_PATH.include?('lib')

require 'majordomus'

Majordomus::CLI.start(ARGV)

