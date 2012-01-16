#
# Cookbook Name:: test
# Recipe:: default
#
# Copyright 2011, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

rs_utils_marker :begin



repo "repo_svn" do
  destination "/tmp/repo"
  repository node[:repo_test][:repository]
  revision node[:repo_test][:revision]
  provider_type node[:repo_test][:provider_type]
  svn_username node[:repo_test][:svn_username]
  svn_password node[:repo_test][:svn_password]
  action :capistrano_pull
  provider node[:repo_test][:provider_type] #"repo_svn"
end

rs_utils_marker :end


