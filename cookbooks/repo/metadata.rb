maintainer       "RightScale, Inc."
maintainer_email "support@rightscale.com"
license          IO.read(File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'LICENSE')))
description      "Abstract cookbook for managing source code repositories."
long_description "Provides a chef lightweight resource called 'repo' as a Bridge to repo_svn and repo_git cookbooks."
version          "0.0.1"

depends "repo_svn"
depends "repo_git"

recipe  "repo::default", "Default recipe for setup resources provided"
recipe  "repo::do_pull", "Recipe for pulling project repos"

grouping "repo/default",
 :display_name => "Git Client Default Settings",
 :description => "Settings for managing a Git source repository",
 :databag => true       # proposed metadata addition

attribute "repo/default/provider_type",
  :display_name => "Repository Provider Type",
  :description => "",
  :choice => ["repo_git", "repo_svn", "repo_ros"],
  :default => "repo_git",
  :recipes => ["repo::default"]

attribute "repo/default/repository",
  :display_name => "Repository Url",
  :description => "",
  :required => true,
  :recipes => ["repo::default"]

attribute "repo/default/branch",
  :display_name => "Branch/Tag",
  :description => "",
  :required => false,
  :recipes => ["repo::default"]

attribute "repo/svn/svn_username",
  :display_name => "svn_username",
  :description => "svn_username",
  :default => "",
  :recipes => ["repo::default"]

attribute "repo/svn/svn_password",
  :display_name => "svn_password",
  :description => "svn_password",
  :default => "",
  :recipes => ["repo::default"]


#attribute "repo/default/depth",
#  :display_name => "Depth",
#  :description => "",
#  :default => nil,
#  :required => false

#attribute "repo/default/enable_submodules",
#  :display_name => "Enable Submodules",
#  :description => "",
#  :default => "false",
#  :required => false

#attribute "repo/default/remote",
#  :display_name => "Remote",
#  :description => "",
#  :default => "origin",
#  :required => false

attribute "repo/git/ssh_key",
  :display_name => "SSH Key",
  :description => "",
  :default => nil,
  :required => false,
  :recipes => ["repo::default"]

  
  