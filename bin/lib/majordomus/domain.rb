
module Majordomus
  
  def domain_add(rname, domain)
    meta = Majordomus::application_metadata? rname
    return if meta['domains'].include? domain
    
    meta['domains'] << domain
    Majordomus::application_metadata! rname, meta
    
  end
  
  def domain_remove(rname, domain)
    meta = Majordomus::application_metadata? rname
    return if !meta['domains'].include? domain
    
    meta['domains'].delete domain
    Majordomus::application_metadata! rname, meta
    
  end
  
  module_function :domain_add, :domain_remove
end
