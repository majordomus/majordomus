
module Majordomus
  
  def create_site_config(rname)
    meta = Majordomus::application_metadata? rname
    type = Majordomus::application_type?(rname)
    
    meta['domains'].each do |domain|
      conf_file = "#{domain.gsub(".","_")}.conf"
      if type == 'static'
        config = static_config(rname, domain)
      else
        config = dynamic_config(domain, Majordomus::forward_ip(rname), Majordomus::forward_port(rname))
      end
      File.open("#{Majordomus::majordomus_data}/tmp/#{conf_file}", "w") { |f| f.write(config) }
      Majordomus::execute "sudo mv #{Majordomus::majordomus_data}/tmp/#{conf_file} /etc/nginx/sites-enabled/#{conf_file}"
    end
  end
  
  def remove_site_config(rname)
    meta = Majordomus::application_metadata? rname
    meta['domains'].each do |domain|
      Majordomus::execute "sudo rm /etc/nginx/sites-enabled/#{domain.gsub(".","_")}.conf"
    end
  end
  
  def reload_web
    Majordomus::execute "sudo service nginx reload"
  end
  
  def static_config(rname, domain)
    conf = <<-EOF
server {
  listen 80;
  
  server_name #{domain};
  
  # Expose this directory as static files.
  root #{Majordomus::majordomus_data}/www/#{rname};
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
  
  module_function :create_site_config, :remove_site_config, :reload_web, :static_config, :dynamic_config
  
end
