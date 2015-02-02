
module Majordomus
  
  def launch_container(name)
    rname = Majordomus::internal_name? name
    meta = Majordomus::application_metadata? rname
    
    # add changed ENV to the command line
    e = ""
    meta['env'].each do |env|
      if Majordomus::config_value(rname,env[0]) != env[1]
        e << " -e #{env[0]}='#{Majordomus::config_value rname,env[0]}'"
      end
    end
    
    # list of exposed & mapped ports
    p = ""
    ports = Majordomus::kv_keys? "apps/meta/#{rname}/port"
    if ports
      ports.each do |key|
        ep = key.split('/')[4]
        mp = Majordomus::get_kv key
        p << " -p #{mp}:#{ep}"
      end
    end
    
    cmd = "docker run -d --name='#{rname}' --dns=8.8.8.8 #{e} #{p} #{name}"
    Majordomus::execute cmd
     
  end
  
  def start_container(name)
  end
  
  def stop_container(name)
  end
  
  module_function :launch_container, :start_container, :stop_container
end
