#
# Cookbook Name:: test
# Recipe:: default
#
# Copyright 2011, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

rs_utils_marker :begin

#Upload test repo to ROS

cookbook_file "/tmp/example.tar.gz" do
  source "examples.tar.gz"
end

test_file = "/tmp/example.tar.gz"
cloud_file = "example.tar.gz"
container   = node[:repo_test][:container]
cloud       = ( node[:repo_test][:storage_account_provider] == "CloudFiles" ) ? "rackspace" : "ec2"

execute "Upload dumpfile to Remote Object Store" do
  command "/opt/rightscale/sandbox/bin/ros_util put --cloud #{cloud} --container #{container} --dest #{cloud_file} --source #{test_file}"
  environment ({
    'STORAGE_ACCOUNT_ID' => node[:repo_test][:storage_account_id],
    'STORAGE_ACCOUNT_SECRET' => node[:repo_test][:storage_account_secret]
  })
end



 #The sample that we will use in app servers "code_update" recipes
repo "Get code repo" do
  destination "/tmp/repo"
  repository node[:repo_test][:repository]
  revision node[:repo_test][:revision]
#  provider_type node[:repo_test][:provider_type]
  svn_username node[:repo_test][:svn_username]
  svn_password node[:repo_test][:svn_password]
  ssh_key node[:repo_test][:ssh_key]
  action :pull
  provider node[:repo_test][:provider_type] #"repo_svn"

  app_user "rightscale"
  create_dirs_before_symlink %w{log dir2}
  symlinks ({"log"=>"public/log"})

  storage_account_provider node[:repo_test][:storage_account_provider]
  storage_account_id node[:repo_test][:storage_account_id]
  storage_account_secret node[:repo_test][:storage_account_secret]
  container node[:repo_test][:container]
  prefix node[:repo_test][:prefix]

end

rs_utils_marker :end


