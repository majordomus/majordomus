
module Majordomus
  
  def create_application(name, type)
    
    # create a random name for internal use
    begin
      rname = Majordomus::random_name
    end while Majordomus::kv_key? "apps/cname/#{rname}"
    
    # basic data in the consul index
    Majordomus::canonical_name! rname, name
    Majordomus::internal_name! name,rname
    
    # basic metadata
    meta = {
      "name" => name,
      "internal" => rname,
      "type" => type,
      "status" => "created"
    }
    Majordomus::application_metadata! rname, meta
    
    if type == "static"
      Majordomus::execute "sudo mkdir -p #{majordomus_data}/www/#{rname}"
    end
    
    return rname
  end
  
  def remove_application(name)
    
    # get the random name
    rname = Majordomus::internal_name? name
    meta = Majordomus::application_metadata? rname
    
    # stop the app
    
    # remove port mapping
    ports = Majordomus::defined_ports name
    ports.each do |p|
      port = p.split('/')[0]
      Majordomus::release_port Majordomus::port_mapped_to rname, port
    end
    
    # cleanup consul
    Majordomus::delete_kv "apps/iname/#{name}"
    Majordomus::delete_kv "apps/cname/#{rname}"
    Majordomus::delete_all_kv "apps/meta/#{rname}"
    
    if meta['type'] == "static"
      Majordomus::execute "sudo rm -rf #{majordomus_data}/www/#{rname}"
    end
    
    # drop the git repo
    Majordomus::execute "sudo rm -rf #{majordomus_data}/git/#{name}"
    
    return rname
  end
  
  def internal_name!(name,rname)
    Majordomus::put_kv "apps/iname/#{name}", rname
  end
  
  def internal_name?(name)
    Majordomus::get_kv "apps/iname/#{name}"
  end
  
  def canonical_name!(rname,name)
    Majordomus::put_kv "apps/cname/#{rname}", name
  end
  
  def canonical_name?(rname)
    Majordomus::get_kv "apps/cname/#{rname}"
  end
  
  def application_metadata?(rname)
    JSON.parse( Majordomus::get_kv("apps/meta/#{rname}"))
  end
  
  def application_metadata!(rname, meta)
    @consul_mutex.synchronize do
      Majordomus::put_kv "apps/meta/#{rname}", meta.to_json
    end
  end
  
  def application_exists?(name)
    Majordomus::kv_key? "apps/iname/#{name}"
  end
  
  def application_status?(rname)
    Majordomus::application_metadata?(rname)['status']
  end
  
  def application_type?(rname)
    Majordomus::application_metadata?(rname)['type']
  end
  
  def application_status!(rname,status)
    meta = Majordomus::application_metadata? rname
    meta['status'] = status
    Majordomus::application_metadata! rname, meta
  end
  
  def config_set(rname,key,value)
    Majordomus::put_kv "apps/meta/#{rname}/env/#{key}", "#{value}"
  end
  
  def config_remove(rname,key)
    Majordomus::delete_kv "apps/meta/#{rname}/env/#{key}"
  end
  
  def config_value?(rname,key)
    Majordomus::kv_key? "apps/meta/#{rname}/env/#{key}"
  end
  
  def config_value(rname,key)
    Majordomus::get_kv "apps/meta/#{rname}/env/#{key}"
  end
        
  def port_mapped_to(rname, exposed_port)
    Majordomus::get_kv "apps/meta/#{rname}/port/#{exposed_port}"
  end
  
  def port_assigned?(port)
    Majordomus::kv_key? "ports/#{port}"
  end
  
  def port_exposed?(rname, exposed_port)
    Majordomus::kv_key? "apps/meta/#{rname}/port/#{exposed_port}"
  end
  
  def map_port(rname, exposed_port, mapped_port)
    Majordomus::put_kv "ports/#{mapped_port}", "#{exposed_port}/#{rname}"
    Majordomus::put_kv "apps/meta/#{rname}/port/#{exposed_port}", "#{mapped_port}"
  end
  
  def release_port(mapped_port)
    Majordomus::delete_kv "ports/#{mapped_port}"
  end
  
  def forward_port(rname)
    Majordomus::application_metadata?(rname)['forward_port']
  end
  
  def forward_ip(rname)
    Majordomus::application_metadata?(rname)['forward_ip']
  end
  
  def info(name)
    
    rname = Majordomus::internal_name? name
    
    puts "Application: #{name} -> internal name: #{rname}"
    puts "Status: #{Majordomus::application_status? rname}"
    
    puts "\nMetadata:\n"
    puts "  #{Majordomus::application_metadata? rname}"
    
    puts "\nEnvironment:\n"
    env_keys = Majordomus::kv_keys? "apps/meta/#{rname}/env"
    if env_keys
      env_keys.each do |e|
        puts "  ENV['#{e.split("/",5)[4]}']=#{Majordomus::get_kv e}"
      end
    end
  
    puts "\nExposed Ports:\n"
    port_keys = Majordomus::kv_keys? "apps/meta/#{rname}/port"
    if port_keys
      port_keys.each do |p|
        puts "  #{Majordomus::get_kv p} -> #{p.split("/",5)[4]}"
      end
    end
    
  end
  
  def list
    apps = Majordomus::kv_keys? "apps/cname"
    
    if apps
      
      apps.each do |a|
        rname = a.split("/",3)[2]
        name = Majordomus::canonical_name? rname
      
        puts "  #{name} --> #{rname} (#{Majordomus::application_type? rname})\tSTATE: #{Majordomus::application_status? rname}"
      end
      
    end
  end
  
  module_function :create_application, :remove_application, :internal_name?, :internal_name!,
    :canonical_name?, :canonical_name!, :application_exists?, :application_metadata?, :application_metadata!, 
    :application_status?, :application_status!, :application_type?, :info, :list, 
    :config_set, :config_remove, :config_value?, :config_value, 
    :port_mapped_to, :port_assigned?, :port_exposed?, :map_port, :release_port,
    :forward_ip, :forward_port
    
end
