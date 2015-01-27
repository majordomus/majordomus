
require 'excon'
require 'base64'

module Majordomus

  def get_kv(key)
    con = Excon.new(consul_url)
    response = con.get(:path => "/v1/kv/#{key}")
    
    return nil unless response.status == 200
    
    Base64.decode64( JSON.parse(response.body[1,response.body.length-2])['Value'])
  end
  
  def put_kv(key, value)
    con = Excon.new(consul_url)
    response = con.put(:path => "/v1/kv/#{key}", :body => value)
    
    response.status
  end
   
  def delete_kv(key)
    con = Excon.new(consul_url)
    response = con.delete(:path => "/v1/kv/#{key}")
    
    return response.status
  end
  
  def kv_key?(key)
    con = Excon.new(consul_url)
    response = con.get(:path => "/v1/kv/#{key}")
    
    return false unless response.status == 200
    true
  end
  
  def kv_keys(key)
    con = Excon.new(consul_url)
    response = con.get(:path => "/v1/kv/#{key}?keys")
    
    return nil unless response.status == 200
    
    JSON.parse(response.body) 
  end
  
  module_function :get_kv, :put_kv, :delete_kv, :kv_key?, :kv_keys
  
end
  