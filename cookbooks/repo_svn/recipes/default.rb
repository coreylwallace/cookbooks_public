#
# Cookbook Name:: repo_svn
# Recipe:: default
#
#
# Copyright RightScale, Inc. All rights reserved.  All access and use subject to the
# RightScale Terms of Service available at http://www.rightscale.com/terms.php and,
# if applicable, other agreements such as a RightScale Master Subscription Agreement.

rs_utils_marker :begin

PROVIDER_NAME = "repo_svn"  # grab this from cookbook directory name

unless node[:platform] == "mac_os_x" then
  # install subversion client
  package "subversion" do
    action :install
  end

  extra_packages = case node[:platform]
    when "ubuntu","debian"
      if node[:platform_version].to_f < 8.04
        %w{subversion-tools libsvn-core-perl}
      else
        %w{subversion-tools libsvn-perl}
      end
    when "centos","redhat","fedora"
      %w{subversion-devel subversion-perl}
    end

  extra_packages.each do |pkg|
    package pkg do
      action :install
    end
  end
end

rs_utils_marker :end
=begin
# Setup all Subversion resources that have attributes in the node.
node[:repo].each do |resource_name, entry| 
  if entry[:provider] == PROVIDER_NAME then
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
      
      persist true      # developed by RightScale (to contribute)
    end
  end
end
=end