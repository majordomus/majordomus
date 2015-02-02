
module Majordomus
  
  def build_application(name)
    
    rname = Majordomus::internal_name? name
    meta = Majordomus::application_metadata? rname
    
    if meta['type'] == 'static'
      Majordomus::execute "sudo rm -rf #{majordomus_data}/www/#{rname} && sudo cp -rf #{majordomus_data}/git/#{name}/ #{majordomus_data}/www/#{rname}"
    else
      
      # build or pull an image
      
      repo = "#{majordomus_data}/git/#{name}"
      dockerfile = "#{repo}/Dockerfile"
      
      if File.exists? dockerfile 
        Majordomus::execute "cd #{repo} && docker build -t #{name} ."
      else
        Majordomus::execute "docker pull #{name}"
      end
      
      meta = Majordomus::application_metadata? rname
      
      # extract some metadata from the image
      env = Majordomus::defined_params name, ['HOME','PATH']
      ports = Majordomus::defined_ports name
      
      # add ENV to metadata
      meta['env'] = env
      env.keys.each do |e|
        Majordomus::config_set rname, e, env[e] unless Majordomus::config_value? rname, e
      end
      
      # add ports to metadata and detect any 'forwardable' ports e.g. 80,3000 etc
      forward_port = ""
      meta['ports'] = ports
      ports.each do |p|
        port = p.split('/')[0]
        forward_port = port if ['80','8080','3000'].include? port
        
        Majordomus::map_port rname, port, Majordomus::find_free_port(port) unless Majordomus::port_exposed? rname, port
        
      end
      meta['forward_port'] = forward_port
      meta['forward_ip'] = '127.0.0.1'
      
      Majordomus::application_metadata! rname, meta
    
    end
    
  end
  
  def find_free_port(port)
    begin
      mapped = 20000 + rand(1000)
    end while Majordomus::port_assigned? mapped
    mapped
  end
  
  module_function :build_application, :find_free_port
  
end
