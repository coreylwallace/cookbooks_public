#
# Cookbook Name:: repo_ros
# Provider:: repo_ros
#
#
# Copyright RightScale, Inc. All rights reserved.  All access and use subject to the
# RightScale Terms of Service available at http://www.rightscale.com/terms.php and,
# if applicable, other agreements such as a RightScale Master Subscription Agreement.

action :pull do

      log "trying to get ros repo from: #{new_resource.storage_account_provider}, bucket: #{new_resource.container}"

    raise "Repo container name not provided." unless new_resource.container
    raise "Storage account provider ID not provided" unless new_resource.storage_account_id
    raise "Storage account secret not provided" unless new_resource.storage_account_secret


  # Check variables and log/skip if not set
#  skip, reason = true, "Repo container name not provided"      if new_resource.prefix == ""
#  skip, reason = true, "Storage account provider not provided" if new_resource.storage_account_provider == ""
#  skip, reason = true, "Container not provided"                if new_resource.container == ""

#  if skip
#    log "Skipping import: #{reason}"
#  else

  prefix       = new_resource.prefix
  tmp_repo_path = "/tmp/" + prefix
  container    = new_resource.container
  cloud        = ( new_resource.storage_account_provider == "CloudFiles" ) ? "rackspace" : "ec2"

  # Obtain the source from ROS
  execute "Download #{container} from Remote Object Store" do
    command "/opt/rightscale/sandbox/bin/ros_util get --cloud #{cloud} --container #{container} --dest #{tmp_repo_path} --source #{prefix} --latest"
    creates tmp_repo_path
    environment ({
      'STORAGE_ACCOUNT_ID' => new_resource.storage_account_id,
      'STORAGE_ACCOUNT_SECRET' => new_resource.storage_account_secret
    })
  end
log "ROS get finished"
=begin
  #Bash : unpack repo_path -> new_resource.destination
  bash "Unpack source to project folder" do
    cwd "/tmp"
    code <<-EOH
       tar xzf #{tmp_repo_path} -C #{new_resource.destination}
    EOH
  not_if do File.directory?(tmp_repo_path) end
  end
=end

#  end

end

