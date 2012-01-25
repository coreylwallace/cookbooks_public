maintainer       "RightScale, Inc."
maintainer_email "support@rightscale.com"
license          IO.read(File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'LICENSE')))
description      "Manages the Subversion version control system"
version          "0.0.1"

depends "repo"
depends "rs_tools"

provides "repo"
#provides "repo_ros"
recipe  "repo_ros::default", "Default pattern of loading packages and resources provided"

