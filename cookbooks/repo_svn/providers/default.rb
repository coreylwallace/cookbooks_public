#
# Cookbook Name:: repo_svn
# Provider:: repo_svn
#
#
# Copyright RightScale, Inc. All rights reserved.  All access and use subject to the
# RightScale Terms of Service available at http://www.rightscale.com/terms.php and,
# if applicable, other agreements such as a RightScale Master Subscription Agreement.

action :pull do
 
  # setup parameters 
  password = new_resource.svn_password
  branch = new_resource.revision
  params = "--no-auth-cache --non-interactive"
  params << " --username #{new_resource.svn_username} --password #{password}" if "#{password}" != ""
  params << " --revision #{branch}" if "#{branch}" != ""

  # pull repo (if exist)
  ruby_block "Pull existing Subversion repository at #{new_resource.destination}" do
    only_if do ::File.directory?(new_resource.destination) end
    block do
      Dir.chdir new_resource.destination
      Chef::Log.info "Updating existing repo at #{new_resource.destination}"
      Chef::Log.info `svn update #{params} #{new_resource.repository} #{new_resource.destination}` 
    end
  end

  # clone repo (if not exist)
  ruby_block "Checkout new Subversion repository to #{new_resource.destination}" do
    not_if do ::File.directory?(new_resource.destination) end
    block do
      Chef::Log.info "block executed"
      Chef::Log.info "Creating new repo at #{new_resource.destination} #{params} #{new_resource.repository}"
      Chef::Log.info `svn checkout #{params} #{new_resource.repository} #{new_resource.destination}`
    end
  end
 
end


action :capistrano_pull do
  Log "Started capistrano git deployment creation"

  ruby_block "Before deploy" do
    block do
      #check previous repo in case of action change
      if (::File.exists?("#{new_resource.destination}") == true && ::File.symlink?("#{new_resource.destination}") == false)
        ::File.rename("#{new_resource.destination}", "#{new_resource.destination}_old")
      elsif (::File.exists?("#{new_resource.destination}") == true && ::File.symlink?("#{new_resource.destination}") == true && ::File.exists?("/tmp/capistrano_repo") == false)
        ::File.rename("#{new_resource.destination}", "#{new_resource.destination}_old")
      end
    end
  end


  directory "/tmp/capistrano_repo/shared/" do
    recursive true
  end

  scm_prov = Chef::Provider::Subversion

  deploy "/tmp/capistrano_repo" do
    scm_provider scm_prov
    repo "#{new_resource.repository.chomp}"
    revision new_resource.revision
    svn_username new_resource.svn_username
    svn_password new_resource.svn_password
    svn_arguments "--no-auth-cache --non-interactive"
    user new_resource.app_user
    migrate false
    create_dirs_before_symlink new_resource.create_dirs_before_symlink #%w{}
    symlink_before_migrate({})
    symlinks new_resource.symlinks #({})
    action :deploy
  end

  link new_resource.destination do
    action :delete
    only_if "test -L #{new_resource.destination.chomp}"
  end


  ruby_block "After deploy" do
    block do
      system("data=`/bin/date +%Y%m%d%H%M%S` && mv #{new_resource.destination}_old /tmp/capistrano_repo/releases/${data}_initial")

      repo_dest = new_resource.destination
      #checking last symbol of "destination" for correct work of "cp -d"
      if (new_resource.destination.end_with?("/"))
        repo_dest = new_resource.destination.chop
      end
      Chef::Log.warn("symlinking to #{repo_dest}")

      #linking "destination" directory to capistrano "current"
     system("cp -d /tmp/capistrano_repo/current #{repo_dest}")
    end
  end

end