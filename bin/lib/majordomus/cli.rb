
require 'json'
require 'yaml'
require 'excon'
require 'thor'

# The top-level module for the Majordomus API
module Majordomus
  
  class CLI < Thor
    
    def initialize(p1,p2,p3)
      super
    end
    
    desc "init ORGANIZATION APP", "Initialize a new application for organization"
    def init(organization, app)
      puts "*** INIT #{organization}/#{app}"
    end
        
    desc "build ORGANIZATION APP", "Build an new image for application"
    def build(organization, app)
      puts "*** BUILD #{organization}/#{app}"
    end
    
  end # class CLI
  
end


