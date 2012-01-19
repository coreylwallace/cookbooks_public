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
  ssh_key node[:repo_test][:ssh_key]
  action :capistrano_pull
  provider node[:repo_test][:provider_type] #"repo_svn"

  app_user "apache" #attribute :app_user, :kind_of => String
 create_dirs_before_symlink %w{dir1, dir2} #attribute :create_dirs_before_symlink, :kind_of => Array, :default => %w{}
 symlink_before_migrate ({"dir1"=>"dir3"}) #attribute :symlink_before_migrate, :kind_of => Hash, :default => ({})
attribute :symlinks, :kind_of => Hash, :default => ({})
end

rs_utils_marker :end


