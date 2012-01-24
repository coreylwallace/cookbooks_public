#
# Cookbook Name:: repo_svn
# Provider:: repo_svn
#
#
# Copyright RightScale, Inc. All rights reserved.  All access and use subject to the
# RightScale Terms of Service available at http://www.rightscale.com/terms.php and,
# if applicable, other agreements such as a RightScale Master Subscription Agreement.

action :pull do
  
# Check variables and log/skip if not set
#skip, reason = true, "DB/Schema name not provided"           if node[:db][:dump][:database_name] == ""
skip, reason = true, "Repo container name not provided"      if new_resource.prefix == ""   #node[:db][:dump][:prefix]
skip, reason = true, "Storage account provider not provided" if new_resource.storage_account_provider == ""  #node[:db][:dump][:storage_account_provider]
skip, reason = true, "Container not provided"                if new_resource.container == ""  #node[:db][:dump][:container]

  if skip
    log "Skipping import: #{reason}"
  else

    #db_name      = node[:db][:dump][:database_name]
    prefix       = node[:db][:dump][:prefix]
    tmp_repo_path = "/tmp/" + prefix + ".gz" #dumpfilepath
    container    = new_resource.container #node[:db][:dump][:container]
    cloud        = ( new_resource.storage_account_provider == "CloudFiles" ) ? "rackspace" : "ec2"

  # Obtain the source from ROS
    execute "Download #{container} from Remote Object Store" do
      command "/opt/rightscale/sandbox/bin/ros_util get --cloud #{cloud} --container #{container} --dest #{tmp_repo_path} --source #{prefix} --latest"
      creates tmp_repo_path
      environment ({
        'STORAGE_ACCOUNT_ID' => new_resource.storage_account_id,  #node[:db][:dump][:storage_account_id],
        'STORAGE_ACCOUNT_SECRET' => new_resource.storage_account_secret #node[:db][:dump][:storage_account_secret]
      })
    end

  #Bash : unpack repo_path -> new_resource.destination
  end

end

#////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#////////////////////////////////////////////////////////////////////////////////////////////////////////////////
