
require 'json'
require 'yaml'
require 'excon'
require 'thor'

# The top-level module for the Majordomus API
module Majordomus
  
  class CLI < Thor
    
    def initialize(p1,p2,p3)
      super
      puts "majordomus version #{Majordomus::VERSION}\n\n"
    end
    
    desc "create TYPE NAME", "Create the metadata for a new app"
    def create(type,name)
            
      if !(type == 'static') && !(type == 'container')
        raise Thor::Error.new("Invalid application type '#{type}'. Expected 'static', 'container'. ")
      end
      
      if Majordomus::application_exists? name
        raise Thor::Error.new("Application '#{name}' already exists. Use a different name.")
      end
      
      return Majordomus::application_create name, type
      
    end

    desc "build NAME", "Build or pull an new image"
    def build(name)
      
      if !Majordomus::application_exists? name
        raise Thor::Error.new("Application '#{name}' does not exist.")
      end
      
      return Majordomus::build_application name
      
    end
    
    desc "launch NAME", "Create a new container based on the current configuration and launch it"
    def launch(name)
      Majordomus::launch_container name
    end
    
    desc "open NAME", "Open the app for traffic"
    def open(name)
      
      if !Majordomus::application_exists? name
        raise Thor::Error.new("Application '#{name}' does not exist.")
      end
      
      rname = Majordomus::internal_name? name
      
      if Majordomus::application_status?(rname) == 'open'
        raise Thor::Error.new("Application '#{name}' is already open for traffic.")
      end
      
      Majordomus::create_site_config rname
      Majordomus::reload_web
      
      Majordomus::application_status! rname, "open"
      
    end
    
    desc "close NAME", "Close the app for traffic"
    def close(name)
      if !Majordomus::application_exists? name
        raise Thor::Error.new("Application '#{name}' does not exist.")
      end
      
      rname = Majordomus::internal_name? name
      
      if Majordomus::application_status?(rname) == 'closed'
        raise Thor::Error.new("Application '#{name}' is already closed for traffic.")
      end
      
      Majordomus::remove_site_config rname
      Majordomus::reload_web
      
      Majordomus::application_status! rname, "closed"
      
    end
    
    desc "config CMD NAME ENV VALUE", "Add/update or remove configuration values"
    def config(cmd, name,env,value=nil)
      
      if !Majordomus::application_exists? name
        raise Thor::Error.new("Application '#{name}' does not exist.")
      end
      
      rname = Majordomus::internal_name? name
      
      if cmd == 'set'
        Majordomus::config_set rname, env, value
      elsif cmd == 'remove'
        Majordomus::config_remove rname, env
      else
        raise Thor::Error.new("Unsupported operation '#{cmd}' for command CONFIG")
      end
    end
    
    desc "domain CMD NAME DOMAIN", "Add or remove a custom domain to the app"
    def domain(cmd, name, domain)
      
      if !Majordomus::application_exists? name
        raise Thor::Error.new("Application '#{name}' does not exist.")
      end
      
      rname = Majordomus::internal_name? name
      
      if cmd == 'add'
        Majordomus::domain_add rname, domain
      elsif cmd == 'remove'
        Majordomus::domain_remove rname, domain
      else
        raise Thor::Error.new("Unsupported operation '#{cmd}' for command DOMAIN")
      end
      
    end
    
    desc "remove NAME", "Remove the app and all its metadata"
    def remove(name)
      
      if !Majordomus::application_exists? name
        raise Thor::Error.new("Application '#{name}' does not exist.")
      end
      
      return Majordomus::remove_application name
      
    end        
    
    desc "info NAME", "Dump all metadata for application #{name}"
    def info(name)
      
      if !Majordomus::application_exists? name
        raise Thor::Error.new("Application '#{name}' does not exist.")
      end
      
      Majordomus::info name
      ""
    end
    
    desc "list", "List all applications"
    def list
      Majordomus::list
      ""
    end
    
  end # class CLI
  
end


