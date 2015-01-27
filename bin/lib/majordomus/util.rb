
require 'excon'
require 'base64'

module Majordomus
  
  @part_1 = ['angry','sweet','lazy','funny','grumpy','noisy','screaming','raging','silly','laughing']
  @part_2 = ['stallman','appelbaum','assange','schneier','zimmermann','torvalds','atkinson','dijkstra','goldberg','turing','kay','knuth','ritchie','matsumoto']
  
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
  
  def check_for_errors(ret)
    error = nil
    parts = ret[1].split('{"errorDetail":')
    if parts.size > 1
      error = parts.last.split(':')
    end
    error
  end
    
  def random_name
    "#{@part_1[rand(@part_1.length)]}_#{@part_2[rand(@part_2.length)]}"
  end
  
  module_function :request_params, :request_get, :request_post, :check_for_errors, :random_name
  
end
