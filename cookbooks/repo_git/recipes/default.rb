#
# Cookbook Name:: repo_git
# Recipe:: default
#
#
# Copyright RightScale, Inc. All rights reserved.  All access and use subject to the
# RightScale Terms of Service available at http://www.rightscale.com/terms.php and,
# if applicable, other agreements such as a RightScale Master Subscription Agreement.

rs_utils_marker :begin

unless node[:platform] == "mac_os_x" then
  # Install git client
  case node[:platform]
  when "debian", "ubuntu"
    package "git-core"
  else 
    package "git"
  end

  package "gitk"
  package "git-svn"
  package "git-email"
end

rs_utils_marker :end

=begin
# Setup all git resources that have attributes in the node.
node[:repo].each do |resource_name, entry| 
  if entry[:provider] == PROVIDER_NAME then
    
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
      
      persist true      # developed by RightScale (to contribute)
    end
  end
end
=end
