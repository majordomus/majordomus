
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
        Majordomus::put_kv "apps/meta/#{rname}/env/#{e}", env[e]
      end
      
      # add ports to metadata
      meta['ports'] = ports
      ports.each do |p|
        parts = p.split '/'
        Majordomus::put_kv "apps/meta/#{rname}/port/#{parts[0]}", parts[0]
      end
      
      Majordomus::application_metadata! rname, meta
    
    end
    
  end
  
  module_function :build_application
  
end
