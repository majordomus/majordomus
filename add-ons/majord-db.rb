#!/usr/bin/env ruby

def database_create_script(name, pwd)
    conf = <<-EOF
CREATE DATABASE #{name}_db;
CREATE USER #{name}_user IDENTIFIED BY '#{pwd}';
GRANT ALL PRIVILEGES ON #{name}_db.* TO #{name}_user;
FLUSH PRIVILEGES;
EXIT;
EOF
  conf
end

def database_drop_script(name)
    conf = <<-EOF
DROP USER #{name}_user;
DROP DATABASE #{name}_db;
FLUSH PRIVILEGES;
EXIT;
EOF
  conf
end

def execute(cmd)
  puts "*** Executing: #{cmd}"
  puts %x[ #{cmd} ]
end

cmd = ARGV[0]

if cmd == "create"
  admin = ARGV[1]
  apwd = ARGV[2]
  name = ARGV[3]
  pwd = ARGV[4]
  
  # create the SQL script to create a DB
  sql_file = "#{ENV['MAJORDOMUS_DATA']}/tmp/create_#{name}.sql"
  script = database_create_script name, pwd
  File.open(sql_file, "w") { |f| f.write(script) }
  
  execute "mysql -u#{admin} -p#{apwd} -h127.0.0.1 -P3306 < #{sql_file}"
  execute "rm #{sql_file}"
  
elsif cmd == "drop"
  admin = ARGV[1]
  apwd = ARGV[2]
  name = ARGV[3]
  
  # create the SQL script to drop the DB
  sql_file = "#{ENV['MAJORDOMUS_DATA']}/tmp/drop_#{name}.sql"
  script = database_drop_script name
  File.open(sql_file, "w") { |f| f.write(script) }
  
  execute "mysql -u#{admin} -p#{apwd} -h127.0.0.1 -P3306 < #{sql_file}"
  execute "rm #{sql_file}"
else
  puts "majord-db"
end