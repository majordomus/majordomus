
require 'json'
require 'yaml'

# The top-level module for the Majordomus API
module Majordomus
  
  require 'majordomus/version'
  require 'majordomus/util'
  require 'majordomus/consul'
  require 'majordomus/docker'
  require 'majordomus/metadata'
  require 'majordomus/web'
  require 'majordomus/cli'
  
  def docker_url
    ENV['DOCKER_URL'] || "http://0.0.0.0:6001"
  end

  def consul_url
    ENV['CONSUL_URL'] || "http://0.0.0.0:8500"
  end

  def majordomus_root
    ENV['MAJORDOMUS_ROOT'] || "/opt/majordomus/majord"
  end
  
  def majordomus_data
    ENV['MAJORDOMUS_DATA'] || "/opt/majordomus/majord-data"
  end
  
  module_function :docker_url, :consul_url, :majordomus_root, :majordomus_data
  
end


