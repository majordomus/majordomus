
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
      
      meta['env'] = env
      meta['ports'] = ports
      
      Majordomus::application_metadata! rname, meta
    
    end
    
    puts Majordomus::application_metadata? rname
    
  end
  
  module_function :build_application
  
end
