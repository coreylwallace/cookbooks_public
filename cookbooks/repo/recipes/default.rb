#
# Cookbook Name:: repo
# Recipe:: default
#
#
# Copyright RightScale, Inc. All rights reserved.  All access and use subject to the
# RightScale Terms of Service available at http://www.rightscale.com/terms.php and,
# if applicable, other agreements such as a RightScale Master Subscription Agreement.



# Setup all git resources that have attributes in the node.
node[:repo].each do |resource_name, entry|
#  if entry[:provider] == PROVIDER_NAME then
   if entry[:provider] == "repo_git" then

    url = entry[:repository]
    raise "ERROR: You did not specify a repository for repo resource named #{resource_name}." unless url
    branch = (entry[:branch]) ? entry[:branch] : "master"
    key = (entry[:ssh_key]) ? entry[:ssh_key] : ""

    # Setup git client
    repo resource_name do
      provider "repo_git"
      repository url
      revision branch
      ssh_key key
      persist true
    end
  end

  if entry[:provider] == "repo_svn" then

    log "trying to pull svn repo at: #{entry[:repository]} with branch #{entry[:branch]}"
    url = entry[:repository]
    raise "ERROR: You did not specify a repository for repo resource named #{resource_name}." unless url
    branch = (entry[:branch]) ? entry[:branch] : "HEAD"
    username = (entry[:username]) ? entry[:username] : ""
    password = (entry[:password]) ? entry[:password] : ""

    # Setup svn client
    repo resource_name do
      provider "repo_svn"
      repository url
      revision branch
      svn_username username
      svn_password password
      persist true
    end
  end
end


