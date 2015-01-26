
module Majordomus
  
  def request_params(args, path, method='POST')
    content_type = 'application/json'
    user_agent = "Majordomus #{Majordomus::VERSION}"

    {
      :method => method,
      :path => path,
      :query => args,
      :headers => {
        'Content-Type' => content_type,
        'User-Agent'   => user_agent
      }
    }
  end

  def request_get(url, path, args={})
    con = Excon.new(url)
    response = con.get( request_params(args, path, 'GET'))
    begin
      [response.status, JSON.parse(response.body)]
    rescue
      [response.status, response.body]
    end
  end

  def request_post(url, path, args={})
    con = Excon.new(url)
    response = con.post( request_params(args, path))
    begin
      [response.status, JSON.parse(response.body)]
    rescue
      [response.status, response.body]
    end
  end # request_post
  
  # create a container instance (docker gem)
  def container?(name_or_id)
    Docker.url = docker_url
    Docker::Container.get(name_or_id)
  end
  
  # create an image instance (docker gem)
  def image?(name_or_id)
    Docker.url = docker_url
    Docker::Image.get(name_or_id)
  end
  
  def check_for_errors(ret)
    error = nil
    parts = ret[1].split('{"errorDetail":')
    if parts.size > 1
      error = parts.last.split(':')
    end
    error
  end
  
  module_function :request_params, :request_get, :request_post, :container?, :image?, :check_for_errors
  
end
