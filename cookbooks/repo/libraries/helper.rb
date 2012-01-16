#
# Cookbook Name:: repo
#
# Copyright RightScale, Inc. All rights reserved.  All access and use subject to the
# RightScale Terms of Service available at http://www.rightscale.com/terms.php and,
# if applicable, other agreements such as a RightScale Master Subscription Agreement.

module RightScale
  module Repo
    module Helper
   #   def init
    #    self
   #   end
   #
  def self.capistrano_pull(destination,repository,revision)

    shared_dir = Chef::Resource::Directory.new("#{destination.chomp}/shared/")
    shared_dir.path = "#{destination.chomp}/shared/"
    shared_dir.action_create
    #Chef::Directory "#{destination.chomp}/shared/" do
    #  recursive true
    #end


  #  deploy destination do
  #    repo "#{repository.chomp}"
  #    revision revision
  #    #user node[:tomcat][:app_user]
  #    enable_submodules true
  #    migrate false
  #    create_dirs_before_symlink %w{}
  #    symlink_before_migrate({})
  #    symlinks({})
  #    shallow_clone true
  #    action :deploy
  #    #restart_command "touch tmp/restart.txt" #"/etc/init.d/tomcat6 restart"
  #  end


  end
=begin
      module Helper
        
      	require 'timeout'
      	require 'yaml'

      	SNAPSHOT_POSITION_FILENAME = 'rs_snapshot_position.yaml'
      	DEFAULT_CRITICAL_TIMEOUT = 7

        def mycnf_uuid
          node[:db_mysql][:mycnf_uuid] ||= Time.new.to_i
          node[:db_mysql][:mycnf_uuid]
        end

        def init(new_resource)
          begin
            require 'rightscale_tools'
          rescue LoadError
            Chef::Log.warn("This database cookbook requires our premium 'rightscale_tools' gem.")
            Chef::Log.warn("Please contact Rightscale to upgrade your account.")
          end
          mount_point = new_resource.name
          RightScale::Tools::Database.factory(:mysql, new_resource.user, new_resource.password, mount_point, Chef::Log)
        end

      	def self.load_replication_info(node)
      	  loadfile = ::File.join(node[:db][:data_dir], SNAPSHOT_POSITION_FILENAME)
      	  Chef::Log.info "Loading replication information from #{loadfile}"
      	  YAML::load_file(loadfile)
      	end

      	def self.get_mysql_handle(node, hostname = 'localhost')
      	  info_msg = "MySQL connection to #{hostname}"
      	  info_msg << ": opening NEW MySQL connection."
      	  con = Mysql.new(hostname, node[:db][:admin][:user], node[:db][:admin][:password])
      	  Chef::Log.info info_msg
      	  # this raises if the connection has gone away
      	  con.ping
      	  return con
      	end

      	def self.do_query(node, query, hostname = 'localhost', timeout = nil, tries = 1)
      	  require 'mysql'

      	  while(1) do
      	    begin
      	      info_msg = "Doing SQL Query: HOST=#{hostname}, QUERY=#{query}"
      	      info_msg << ", TIMEOUT=#{timeout}" if timeout
      	      info_msg << ", NUM_TRIES=#{tries}" if tries > 1
      	      Chef::Log.info info_msg
      	      result = nil
      	      if timeout
      		      SystemTimer.timeout_after(timeout) do
            		  con = get_mysql_handle(node, hostname)
            		  result = con.query(query)
            		end
      	      else
            		con = get_mysql_handle(node, hostname)
            		result = con.query(query)
      	      end
      	      return result.fetch_hash if result
      	      return result
      	    rescue Timeout::Error => e
      	      Chef::Log.info("Timeout occured during mysql query:#{e}")
      	      tries -= 1
      	      raise "FATAL: retry count reached" if tries == 0
      	    end
      	  end
      	end

        def self.reconfigure_replication(node, hostname = 'localhost', newmaster_host = nil, newmaster_logfile=nil, newmaster_position=nil)
          Chef::Log.info "Configuring with #{newmaster_host} logfile #{newmaster_logfile} position #{newmaster_position}"

          # The slave stop can fail once (only throws warning if slave is already stopped)
          RightScale::Database::MySQL::Helper.do_query(node, "STOP SLAVE", hostname)
          RightScale::Database::MySQL::Helper.do_query(node, "STOP SLAVE", hostname)

          cmd = "CHANGE MASTER TO MASTER_HOST='#{newmaster_host}'"
          cmd = cmd +          ", MASTER_LOG_FILE='#{newmaster_logfile}'"
          cmd = cmd +          ", MASTER_LOG_POS=#{newmaster_position}"
          Chef::Log.info "Reconfiguring replication on localhost: \n#{cmd}"
          # don't log replication user and password
          cmd = cmd +          ", MASTER_USER='#{node[:db][:replication][:user]}'"
          cmd = cmd +          ", MASTER_PASSWORD='#{node[:db][:replication][:password]}'"
          RightScale::Database::MySQL::Helper.do_query(node, cmd, hostname)

          RightScale::Database::MySQL::Helper.do_query(node, "START SLAVE", hostname)
          started=false
          10.times do
            row = RightScale::Database::MySQL::Helper.do_query(node, "SHOW SLAVE STATUS", hostname)
            slave_IO = row["Slave_IO_Running"].strip.downcase
            slave_SQL = row["Slave_SQL_Running"].strip.downcase
            if( slave_IO == "yes" and slave_SQL == "yes" ) then
              started=true
              break
            else
              Chef::Log.info "threads at new slave not started yet...waiting a bit more..."
              sleep 2
            end
          end
          if( started )
            Chef::Log.info "Slave threads on the master are up and running."
          else
            Chef::Log.info "Error: slave threads in the master do not seem to be up and running..."
          end
        end
      end
=end
    end
  end
end
