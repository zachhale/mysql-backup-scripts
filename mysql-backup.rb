#!/usr/bin/env ruby -wKU

# ================================
# = MySQL database backup script =
# ================================
# 
# Backs up databases to a file called [database_name].sql


DBUSER = ARGV[0]
DBPASSWORD = ARGV[1]

if DBUSER
  def run(command, input="")
    IO.popen(command, 'r+') do |io|
      io.puts input
      io.close_write
      return io.read
    end
  end

  databases = run("mysql -u#{DBUSER} #{"-p#{DBPASSWORD}" if DBPASSWORD} -e 'show databases'").split("\n")

  databases.slice!(0) # remove header from table

  databases.each do |database|
    system "mysqldump -u#{DBUSER} #{"-p#{DBPASSWORD}" if DBPASSWORD} #{database} > #{database}.sql"
    puts "Backed up #{database} to #{database}.sql"
  end
else
  puts "Usage: mysql-backup.rb username password"
end