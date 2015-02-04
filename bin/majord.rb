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
  puts "\n*** Executing: #{cmd}"
  puts %x[ #{cmd} ]
end

def push_static(user, name)
  execute "rm -rf #{majordomus_data}/www/#{name} && cp -rf #{majordomus_data}/git/#{user}/#{name}/ #{majordomus_data}/www/#{name}"
end

def push_container(repo, user, name)
  execute "cd #{repo} && docker build -t #{user}/#{name} ."
end

# parse the command line parameters and do something
cmd = ARGV[0]

if cmd == "PUSH"
  
  repo = ARGV[1]
  org = ARGV[2]
  name = ARGV[3]
  
  if File.exists? "#{repo}/Dockerfile"
    push_container repo, org, name
  else
    push_static org, name
    
    # create nginx config
    domain = "#{name}.#{domain_name}"
    conf_file = "#{domain.gsub(".","_")}.conf"
    config = static_config name, "#{domain}"
    
    File.open("#{majordomus_data}/tmp/#{conf_file}", "w") { |f| f.write(config) }
    execute "mv #{majordomus_data}/tmp/#{conf_file} /etc/nginx/sites-enabled/#{conf_file}"
    
    #execute "sudo service nginx restart"
  end
  
elsif cmd == "BUILD"
  puts "BUILD"
else
  puts "FOO!"
end
