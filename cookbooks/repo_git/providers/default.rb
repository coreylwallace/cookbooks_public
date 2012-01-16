# Cookbook Name:: repo
# Provider:: repo_git
#
# Copyright RightScale, Inc. All rights reserved.  All access and use subject to the
# RightScale Terms of Service available at http://www.rightscale.com/terms.php and,
# if applicable, other agreements such as a RightScale Master Subscription Agreement.

include RightScale::Database::MySQL::Helper
include RightScale::Repo::Helper

action :pull do
 
  # add ssh key and exec script
  keyfile = nil
  keyname = new_resource.ssh_key
  if "#{keyname}" != ""
    keyfile = "/tmp/gitkey"
    bash 'create_temp_git_ssh_key' do
      code <<-EOH
        echo -n '#{keyname}' > #{keyfile}
        chmod 700 #{keyfile}
        echo 'exec ssh -oStrictHostKeyChecking=no -i #{keyfile} "$@"' > #{keyfile}.sh
        chmod +x #{keyfile}.sh
      EOH
    end
  end 

  # pull repo (if exist)
  ruby_block "Pull existing git repository at #{new_resource.destination}" do
    only_if do ::File.directory?(new_resource.destination) end
    block do
      Dir.chdir new_resource.destination
      puts "Updating existing repo at #{new_resource.destination}"
      ENV["GIT_SSH"] = "#{keyfile}.sh" unless ("#{keyfile}" == "")
      puts `git pull` 
    end
  end

  # clone repo (if not exist)
  ruby_block "Clone new git repository at #{new_resource.destination}" do
    not_if do ::File.directory?(new_resource.destination) end
    block do
      puts "Creating new repo at #{new_resource.destination}"
      ENV["GIT_SSH"] = "#{keyfile}.sh" unless ("#{keyfile}" == "")
      puts `git clone #{new_resource.repository} -- #{new_resource.destination}`
      branch = new_resource.revision
      if "#{branch}" != "master" 
        dir = "#{new_resource.destination}"
        Dir.chdir(dir) 
        puts `git checkout --track -b #{branch} origin/#{branch}`
      end
    end
  end

  # delete SSH key & clear GIT_SSH
  if keyfile != nil
     bash 'delete_temp_git_ssh_key' do
       code <<-EOH
         rm -f #{keyfile}
         rm -f #{keyfile}.sh
       EOH
     end
  end
 
end

action :capistrano_pull do

#RightScale::Repo::Helper.add_ssh_key
  RightScale::Repo::Helper.capistrano_pull(new_resource.destination,new_resource.repository,new_resource.revision)
=begin
  directory "#{new_resource.destination.chomp}/shared/" do
    recursive true
  end

  deploy new_resource.destination do
    repo "#{new_resource.repository.chomp}"
    revision new_resource.revision
    #user node[:tomcat][:app_user]
    enable_submodules true
    migrate false
    create_dirs_before_symlink %w{}
    symlink_before_migrate({})
    symlinks({})
    shallow_clone true
    action :deploy
    #restart_command "touch tmp/restart.txt" #"/etc/init.d/tomcat6 restart"
  end
=end

end