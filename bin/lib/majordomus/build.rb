
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
        Majordomus::execute "cd #{repo} && docker build #{name} ."
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
      
      # add ports to metadata
      meta['ports'] = ports
      ports.each do |p|
        port = p.split('/')[0]
        key = "apps/meta/#{rname}/port/#{port}"
        
        Majordomus::put_kv key, "#{Majordomus::map_port port, rname}" unless Majordomus::kv_key? key
        
      end
      
      Majordomus::application_metadata! rname, meta
    
    end
    
  end
  
  def map_port(port, rname)
    begin
      mapped = 20000 + rand(1000)
    end while Majordomus::kv_key? "ports/#{mapped}"
    
    Majordomus::put_kv "ports/#{mapped}", "#{port}/#{rname}"
    mapped
  end
  
  module_function :build_application, :map_port
  
end
