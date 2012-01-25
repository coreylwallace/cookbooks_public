maintainer       "RightScale, Inc."
maintainer_email "support@rightscale.com"
license          IO.read(File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'LICENSE')))
description      "Manages the Git fast version control system"
version          "0.0.1"

depends "git"
depends "repo"

provides "repo"
provides "repo_git"

recipe  "repo_git::default", "Default pattern of loading packages"
