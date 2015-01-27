
module Majordomus
  
  def create_application(name, type)
    
    # create a random name for internal use
    begin
      rname = Majordomus::random_name
    end while Majordomus::kv_key? "uname/#{rname}"
    
    # basic data in the consul index
    Majordomus::put_kv "apps/name/#{name}", rname
    Majordomus::put_kv "uname/#{rname}", name
    
    # basic metadata
    meta = {
      "name" => name,
      "internal" => rname,
      "type" => type
    }
    Majordomus::application_metadata! rname, meta
    
    return rname
  end
  
  def remove_application(name)
    
    # get the random name
    rname = Majordomus::get_kv "apps/name/#{name}"
    
    # stop the app
    
    # cleanup consul
    Majordomus::delete_kv "apps/name/#{name}"
    Majordomus::delete_kv "uname/#{rname}"
    Majordomus::delete_kv "apps/meta/#{rname}"
    
    return rname
  end
  
  def internal_name?(name)
    Majordomus::get_kv "apps/name/#{name}"
  end
  
  def name?(rname)
    Majordomus::get_kv "uname/#{rname}"
  end
  
  def application_metadata?(rname)
    Majordomus::get_kv "apps/meta/#{rname}"
  end
  
  def application_metadata!(rname, meta)
    Majordomus::put_kv "apps/meta/#{rname}", meta.to_s
  end
  
  def application_exists?(name)
    Majordomus::kv_key? "apps/name/#{name}"
  end
  
  module_function :create_application, :remove_application, :internal_name?, :name?, :application_exists?, :application_metadata?, :application_metadata!
    
end
