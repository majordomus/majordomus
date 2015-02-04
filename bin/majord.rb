#!/usr/bin/env ruby

def docker_url
  ENV['MAJORDOMUS_DOCKER_URL'] || "http://0.0.0.0:6001"
end

def majordomus_root
  ENV['MAJORDOMUS_MAJORDOMUS_ROOT'] || "/opt/majordomus/majord"
end

def majordomus_data
  ENV['MAJORDOMUS_DATA'] || "/opt/majordomus/majord-data"
end

def domain_name
  ENV['MAJORDOMUS_DOMAIN_NAME'] || "getmajordomus.local"
end

def static_config(name, domain)
    conf = <<-EOF
server {
  listen 80;
  
  server_name #{domain};
  
  # Expose this directory as static files.
  root #{majordomus_data}/www/#{name};
  index index.html index.htm;
  
  location = /robots.txt {
    log_not_found off;
    access_log off;
  }
  
  location = /favicon.ico {
    log_not_found off;
    access_log off;
  }
}
EOF
  conf
end

def dynamic_config(domain, forward_ip, forward_port)
  conf = <<-EOF
server {
listen 80;

server_name #{domain};

location / {
  proxy_pass http://#{forward_ip}:#{forward_port};
  proxy_set_header X-Forwarded-For $remote_addr;
}
}
EOF
  conf
end

def execute(cmd)
  puts "*** EXECUTING: #{cmd}"
end

def push_static(user, name)
  execute "sudo rm -rf #{majordomus_data}/www/#{name} && sudo cp -rf #{majordomus_data}/git/#{user}/#{name}/ #{majordomus_data}/www/#{name}"
end

def push_container(repo, user, name)
  execute "cd #{repo} && docker build -t #{user}/#{name} ."
end

# parse the command line parameters and do something
cmd = ARGV[0]

if cmd == "PUSH"
  repo = ARGV[1]
  if File.exists? "#{repo}/Dockerfile"
    push_container repo, ARGV[2], ARGV[3]
  else
    push_static ARGV[2], ARGV[3]
  end
elsif cmd == "BUILD"
  puts "BUILD"
else
  puts "FOO!"
end
