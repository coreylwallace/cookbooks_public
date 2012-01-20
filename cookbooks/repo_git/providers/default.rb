# Cookbook Name:: repo
# Provider:: repo_git
#
# Copyright RightScale, Inc. All rights reserved.  All access and use subject to the
# RightScale Terms of Service available at http://www.rightscale.com/terms.php and,
# if applicable, other agreements such as a RightScale Master Subscription Agreement.




action :pull do

  ruby_block "Before pull" do
    block do
      #check previous repo in case of action change
      if (::File.exists?("#{new_resource.destination}") == true && ::File.exists?("#{new_resource.destination}/releases") == true )
        ::File.rename("#{new_resource.destination}", "#{new_resource.destination}_old")
      end
      # add ssh key and exec script
      RightScale::Repo::Ssh_key.new.create(new_resource.ssh_key)
    end
  end

  # add ssh key and exec script
#  keyfile = nil
#  keyname = new_resource.ssh_key
#  if "#{keyname}" != ""
#    keyfile = "/tmp/gitkey"
#    bash 'create_temp_git_ssh_key' do
#      code <<-EOH
#        echo -n '#{keyname}' > #{keyfile}
#        chmod 700 #{keyfile}
#        echo 'exec ssh -oStrictHostKeyChecking=no -i #{keyfile} "$@"' > #{keyfile}.sh
#        chmod +x #{keyfile}.sh
#      EOH
#    end
#  end

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
     RightScale::Repo::Ssh_key.new.delete
#  if keyfile != nil
#     bash 'delete_temp_git_ssh_key' do
#       code <<-EOH
#         rm -f #{keyfile}
#         rm -f #{keyfile}.sh
#       EOH
#     end
#  end
 
end

action :capistrano_pull do
  Log "Started capistrano git deployment creation"
  #RightScale::Repo::Helper.add_ssh_key
  #RightScale::Repo::Helper.new.capistrano_pull(new_resource.destination,new_resource.repository,new_resource.revision)



  ruby_block "Before deploy" do
    block do
      #check previous repo in case of action change
        if (::File.exists?("#{new_resource.destination}") == true && ::File.exists?("/tmp/capistrano_repo") == false )
        ::File.rename("#{new_resource.destination}", "#{new_resource.destination}_old")
      end
   #   if (::File.exists?("#{new_resource.destination}") == true && ::File.exists?("#{new_resource.destination}/releases") == false )
    #    ::File.rename("#{new_resource.destination}", "#{new_resource.destination}_old")
    #  end
      #ssh key
      RightScale::Repo::Ssh_key.new.create(new_resource.ssh_key)
    end
  end



  directory "/tmp/capistrano_repo/shared/" do
    recursive true
  end

#  directory "#{new_resource.deploy_to.chomp}/shared/" do
#    recursive true
#  end

  deploy "/tmp/capistrano_repo" do
    #deploy_to new_resource.deploy_to
    repo "#{new_resource.repository.chomp}"
    revision new_resource.revision
    user new_resource.app_user
    enable_submodules true
    migrate false
    create_dirs_before_symlink new_resource.create_dirs_before_symlink #%w{}
    symlink_before_migrate({})
    symlinks new_resource.symlinks #({})
    shallow_clone false
    action :deploy
    user new_resource.app_user
    #restart_command "touch tmp/restart.txt" #"/etc/init.d/tomcat6 restart"
  end

  #RightScale::Repo::Ssh_key.new.delete
  ruby_block "After deploy" do
    block do
      RightScale::Repo::Ssh_key.new.delete
      system("data=`/bin/date +%Y%m%d%H%M%S` && mv #{new_resource.destination}_old /tmp/capistrano_repo/releases/${data}_initial")

      Chef::Log.warn("app_root is #{new_resource.destination}")

      #checking last symbol of "destination" for correct work of "cp -d"
      if (new_resource.destination.end_with?("/"))
        repo_dest = new_resource.destination.chop
      end
      Chef::Log.warn("symlinking to #{repo_dest}")

      #linking "destination" directory to capistrano "current"
     system("cp -d /tmp/capistrano_repo/current #{repo_dest}")
    end
  end


  link new_resource.destination do
   action :delete
   only_if "test -L #{new_resource.destination.chomp}"
  end




end