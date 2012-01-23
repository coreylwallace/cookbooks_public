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
  #deploy_to "/tmp/repo_deplyed"
  repository node[:repo_test][:repository]
  revision node[:repo_test][:revision]
  provider_type node[:repo_test][:provider_type]
  svn_username node[:repo_test][:svn_username]
  svn_password node[:repo_test][:svn_password]
  ssh_key node[:repo_test][:ssh_key]
  action :capistrano_pull
  provider node[:repo_test][:provider_type] #"repo_svn"

 app_user "rightscale" #attribute :app_user, :kind_of => String
 create_dirs_before_symlink %w{log dir2} #attribute :create_dirs_before_symlink, :kind_of => Array, :default => %w{}
 symlinks ({"log"=>"public/log"}) #attribute :symlinks, :kind_of => Hash, :default => ({})

end

rs_utils_marker :end


