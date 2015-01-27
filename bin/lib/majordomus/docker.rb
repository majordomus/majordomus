
module Majordomus
  
  # returns the name part, removing the tag: 'foo/bar:tag' => 'foo/bar'
  def image_name(image)
    image.split(':')[0]
  end
  
  # returns the tag part of a full image name: 'foo/bar:tag' => 'tag'
  def image_tag(image)
    image.split(':')[1]
  end
  
  # return all image details from the local docker daemon
  def image_metadata(name_or_id)
    ret = request_get(docker_url, "/images/#{name_or_id}/json")
    return nil unless ret[0] == 200
    ret[1]
  end
  
  # return image configuration details from the local docker daemon
  def image_config(name_or_id)
    meta = image_metadata name_or_id
    return meta['Config'] unless meta == nil
    nil
  end
  
  # find an image with the local docker daemon, return its id
  def lookup_image_id(image)
    ret = request_get(docker_url, '/images/json')
    return nil unless ret[0] == 200
    
    ret[1].each do |i|
      return i['Id'] if i['RepoTags'][0] == image
    end
    nil
  end # lookup_image_id
  
  # returns a hash of the images' exposed environment variables, filtering out parameters in 'filter'
  def defined_params(name_or_id,filter = [])
    env = {}
    config = image_config name_or_id
    
    if config
      config['Env'].each do |e|
        ee = e.split('=')
        env.store(ee[0],ee[1]) unless filter.include? ee[0]
      end
    end
    env
  end
  
  # returns an array of exposed ports, incl. its protocol (tcp,udp)
  def defined_ports(name_or_id)
    _ports = []
    config = image_config name_or_id
    if config
      _p = config['ExposedPorts']
      _ports = _p.keys if _p
    end
    _ports
  end
  
  # returns an array of exposed volumes
  def defined_volumes(name_or_id)
    _volumes = []
    config = image_config name_or_id
    if config
      # "Volumes":{"/opt/majordomus/bin":{},"/opt/majordomus/data":{}}
      if config['Volumes']
        config['Volumes'].keys.each do |v|
          _volumes << v
        end
      end
    end
    _volumes
  end
  
  module_function :image_name, :image_tag, :image_metadata, :image_config, 
    :lookup_image_id, :defined_params, :defined_ports, :defined_volumes
    
end
