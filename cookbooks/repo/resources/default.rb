#
# Cookbook Name:: repo
# Resource:: repo

#
# Copyright RightScale, Inc. All rights reserved.  All access and use subject to the
# RightScale Terms of Service available at http://www.rightscale.com/terms.php and,
# if applicable, other agreements such as a RightScale Master Subscription Agreement.
actions :pull
actions :capistrano_pull

attribute :destination, :kind_of => String

attribute :repository, :kind_of => String

#Remote repo Branch or revision
attribute :revision, :kind_of => String

# provider which will be used repo_git, repo_svn, repo_ros
attribute :provider_type, :kind_of => String

#@group[Subversion only] Subversion username
attribute :svn_username, :kind_of => String

#@group[Subversion only] Subversion password
attribute :svn_password, :kind_of => String

#@group[Subversion only] Extra arguments passed to the subversion command
attribute :svn_arguments, :kind_of => String

#@group[Git only]
attribute :ssh_key, :kind_of => String

#@group[Capistrano attributes]

#@group[Capistrano attributes] The "meta root" for your application.
attribute :deploy_to, :kind_of => String

#@group[Capistrano attributes] System user to run the deploy as
attribute :app_user, :kind_of => String

#@group[Capistrano attributes] An array of paths, relative to app root, to be removed from a checkout before symlinking
attribute :purge_before_symlink, :kind_of => Array, :default => %w{}

#@group[Capistrano attributes] Directories to create before symlinking. Runs after purge_before_symlink
attribute :create_dirs_before_symlink, :kind_of => Array, :default => %w{}

#@group[Capistrano attributes] A hash that maps files in the shared directory to their paths in the current release
attribute :symlinks, :kind_of => Hash, :default => ({})

#@group[Capistrano attributes] A hash of the form {"ENV_VARIABLE"=>"VALUE"}
attribute :environment, :kind_of => Hash, :default => ({})

