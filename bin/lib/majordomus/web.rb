
module Majordomus
  
  def reload_web
    `sudo service nginx reload`
  end
  
  module_function :reload_web
  
end
