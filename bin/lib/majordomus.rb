
require 'json'
require 'yaml'

# The top-level module for the Majordomus API
module Majordomus
  
  require 'majordomus/version'
  require 'majordomus/util'
  require 'majordomus/consul'
  require 'majordomus/docker'
  require 'majordomus/metadata'
  require 'majordomus/run'
  require 'majordomus/web'
  require 'majordomus/application'
  require 'majordomus/domain'
  require 'majordomus/cli'
  
  @consul_mutex = Mutex.new
  
  def docker_url
    ENV['MAJORD_DOCKER_URL'] || "http://0.0.0.0:6001"
  end

  def consul_url
    ENV['MAJORD_CONSUL_URL'] || "http://0.0.0.0:8500"
  end

  def majordomus_root
    ENV['MAJORD_MAJORDOMUS_ROOT'] || "/opt/majordomus/majord"
  end
  
  def majordomus_data
    ENV['MAJORD_MAJORDOMUS_DATA'] || "/opt/majordomus/majord-data"
  end
  
  def domain_name
    ENV['MAJORD_DOMAIN_NAME'] || "getmajordomus.local"
  end
  
  module_function :docker_url, :consul_url, :majordomus_root, :majordomus_data, :domain_name
  
end


