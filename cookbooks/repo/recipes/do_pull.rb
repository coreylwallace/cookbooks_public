#
# Cookbook Name:: repo
# Recipe:: do_pull
#
#
# Copyright RightScale, Inc. All rights reserved.  All access and use subject to the
# RightScale Terms of Service available at http://www.rightscale.com/terms.php and,
# if applicable, other agreements such as a RightScale Master Subscription Agreement.


rs_utils_marker :begin



repo "repo_svn" do
  destination "/tmp/repo"
  repository node[:repo][:default][:repository]
  revision node[:repo][:default][:revision]
  action :capistrano_pull
  provider node[:repo][:default][:provider]
  #svn
  svn_username node[:repo][:svn][:svn_username]
  svn_password node[:repo][:svn][:svn_password]
  #git
  ssh_key node[:repo][:git][:ssh_key]
  #ros
  storage_account_provider node[:repo][:ros][:storage_account_provider]
  storage_account_id node[:repo_test][:ros][:storage_account_id]
  storage_account_secret node[:repo_test][:ros][:storage_account_secret]
  container node[:repo_test][:ros][:container]
  prefix node[:repo_test][:ros][:prefix]
end

rs_utils_marker :end


