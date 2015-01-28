
module Majordomus
  
  def create_static_web(rname)
      conf = <<-EOF
server {
  listen 80;
  
  server_name #{rname}.#{Majordomus::domain_name};
  
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
    File.open("#{Majordomus::majordomus_data}/tmp/#{rname}.conf", "w") {|f| f.write(conf) }
    Majordomus::execute "sudo mv #{Majordomus::majordomus_data}/tmp/#{rname}.conf /etc/nginx/sites-enabled/#{rname}.conf"
  end
  
  def remove_static_web(rname)
    Majordomus::execute "sudo rm /etc/nginx/sites-enabled/#{rname}.conf"
  end
  
  def reload_web
    Majordomus::execute "sudo service nginx reload"
  end
  
  module_function :create_static_web, :remove_static_web, :reload_web
  
end
