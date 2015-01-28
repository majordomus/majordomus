
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
    
    desc "create TYPE NAME", "Create the metadata for a new app"
    def create(type,name)
      # TYPE = static | container
      # NAME = organization/name
            
      if !(type == 'static') && !(type == 'container')
        raise Thor::Error.new("Invalid application type '#{type}'. Expected 'static', 'container'. ")
      end
      
      if Majordomus::application_exists? name
        raise Thor::Error.new("Application '#{name}' already exists. Use a different name.")
      end
      
      return Majordomus::create_application name, type
      
    end

    desc "build NAME", "Build or pull an new image"
    def build(name)
      
      if !Majordomus::application_exists? name
        raise Thor::Error.new("Application '#{name}' does not exist.")
      end
      
      return Majordomus::build_application name
      
    end
    
    desc "open NAME", "Open the app for traffic"
    def open(name)
      
      if !Majordomus::application_exists? name
        raise Thor::Error.new("Application '#{name}' does not exist.")
      end
      
      rname = Majordomus::internal_name? name
      
      Majordomus::create_static_web rname
      Majordomus::reload_web
      
    end
    
    desc "close NAME", "Close the app for traffic"
    def close(name)
      if !Majordomus::application_exists? name
        raise Thor::Error.new("Application '#{name}' does not exist.")
      end
      
      rname = Majordomus::internal_name? name
      
      Majordomus::remove_static_web rname
      Majordomus::reload_web
      
    end
    
    desc "remove NAME", "Remove the app and all its metadata"
    def remove(name)
      
      if !Majordomus::application_exists? name
        raise Thor::Error.new("Application '#{name}' does not exist.")
      end
      
      return Majordomus::remove_application name
      
    end        
    
  end # class CLI
  
end


