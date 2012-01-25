maintainer       "RightScale, Inc."
maintainer_email "support@rightscale.com"
license          IO.read(File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'LICENSE')))
description      "Abstract cookbook for managing source code repositories."
long_description "Provides a chef lightweight resource called 'repo' as a Bridge to repo_svn and repo_git cookbooks."
version          "0.0.1"

depends "repo_svn"
depends "repo_git"
depends "repo_ros"

recipe  "repo::default", "Default recipe for setup resources provided"
recipe  "repo::do_pull", "Recipe for pulling project repos from svn, git or ros. Your source will be available in /tmp/repo "

grouping "repo/default",
 :display_name => "Default Client Settings",
 :description => "Common settings for managing a source repository",
 :databag => true

attribute "repo/default/provider",
  :display_name => "Repository Provider",
  :description => "",
  :choice => ["repo_git", "repo_svn", "repo_ros"],
  :default => "repo_git",
  :recipes => ["repo::do_pull"]

attribute "repo/default/repository",
  :display_name => "Repository Url",
  :description => "",
  :required => true,
  :recipes => ["repo::do_pull"]

attribute "repo/default/revision",
  :display_name => "Branch/Tag",
  :description => "",
  :required => false,
  :recipes => ["repo::do_pull"]

#SVN

grouping "repo/svn",
 :display_name => "Svn Client Default Settings",
 :description => "Settings for managing a Svn source repository",
 :databag => true

attribute "repo/svn/svn_username",
  :display_name => "SVN username",
  :description => "Username for SVN repo",
  :default => "",
  :recipes => ["repo::do_pull"]

attribute "repo/svn/svn_password",
  :display_name => "SVN password",
  :description => "Password for SVN repo",
  :default => "",
  :recipes => ["repo::do_pull"]

#GIT

grouping "repo/git",
 :display_name => "Git Client Default Settings",
 :description => "Settings for managing a Git source repository",
 :databag => true

attribute "repo/git/ssh_key",
  :display_name => "SSH Key",
  :description => "",
  :default => nil,
  :required => false,
  :recipes => ["repo::do_pull"]

#ROS

grouping "repo/ros",
 :display_name => "ROS Client Default Settings",
 :description => "Settings for managing a ROS source repository",
 :databag => true

attribute "repo/ros/storage_account_provider",
  :display_name => "ROS Storage Account Provider",
  :description => "Location where dump file will be saved. Used by dump recipes to back up to Amazon S3 or Rackspace Cloud Files.",
  :required => "required",
  :choice => [ "S3", "CloudFiles" ],
  :recipes => ["repo::do_pull"]

attribute "repo/ros/storage_account_id",
  :display_name => "ROS Storage Account ID",
  :description => "In order to write the dump file to the specified cloud storage location, you need to provide cloud authentication credentials. For Amazon S3, use your Amazon access key ID (e.g., cred:AWS_ACCESS_KEY_ID). For Rackspace Cloud Files, use your Rackspace login username (e.g., cred:RACKSPACE_USERNAME).",
  :required => "required",
  :recipes => ["repo::do_pull"]

attribute "repo/ros/storage_account_secret",
  :display_name => "ROS Storage Account Secret",
  :description => "In order to write the dump file to the specified cloud storage location, you will need to provide cloud authentication credentials. For Amazon S3, use your AWS secret access key (e.g., cred:AWS_SECRET_ACCESS_KEY). For Rackspace Cloud Files, use your Rackspace account API key (e.g., cred:RACKSPACE_AUTH_KEY).",
  :required => "required",
  :recipes => ["repo::do_pull"]

attribute "repo/ros/container",
  :display_name => "ROS Dump Container",
  :description => "The cloud storage location where the dump file will be saved to or restored from. For Amazon S3, use the bucket name. For Rackspace Cloud Files, use the container name.",
  :required => "required",
  :recipes => ["repo::do_pull"]

attribute "repo/ros/prefix",
  :display_name => "ROS Dump Prefix",
  :description => "The prefix that will be used to name/locate the backup of a particular database dump. Defines the prefix of the dump file name that will be used to name the backup database dump file, along with a timestamp.",
  :required => "required",
  :recipes => ["repo::do_pull"]
