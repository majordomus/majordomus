
module Majordomus
  
  def build_application(name)
    
    rname = Majordomus::internal_name? name
    meta = Majordomus::application_metadata? rname
    
    if meta['type'] == 'static'
      cmd = "sudo rm -rf #{majordomus_data}/www/#{rname} && sudo cp -rf #{majordomus_data}/git/#{name}/ #{majordomus_data}/www/#{rname}"
      ret = Majordomus::execute cmd
    end
    
  end
  
  module_function :build_application
  
end
