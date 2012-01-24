maintainer       "RightScale, Inc."
maintainer_email "support@rightscale.com"
license          IO.read(File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'LICENSE')))
description      "For version control system testing"
version          "0.0.1"

depends "rs_utils"
depends "repo"
depends "repo_svn"

recipe "repo_test::default", "test recipe for repo* providers"


attribute "repo_test/repository",
  :display_name => "repo_test/repository",
  :description => "repo_test/repository",
  :default => "",
  :recipes => ["repo_test::default"]

attribute "repo_test/revision",
  :display_name => "repo_test/revision",
  :description => "repo_test/revision",
  :default => "",
  :recipes => ["repo_test::default"]

attribute "repo_test/provider_type",
  :display_name => "repo_test/provider_type",
  :description => "repo_test/provider_type",
  :default => "",
  :recipes => ["repo_test::default"]

attribute "repo_test/svn_username",
  :display_name => "repo_test/svn_username",
  :description => "repo_test/svn_username",
  :default => "",
  :recipes => ["repo_test::default"]

attribute "repo_test/svn_password",
  :display_name => "repo_test/svn_password",
  :description => "repo_test/svn_password",
  :default => "",
  :recipes => ["repo_test::default"]

attribute "repo_test/ssh_key",
  :display_name => "repo_test/ssh_key",
  :description => "repo_test/ssh_key",
  :default => "",
  :recipes => ["repo_test::default"]

attribute "repo_test/storage_account_provider",
  :display_name => "Dump Storage Account Provider",
  :description => "Location where dump file will be saved. Used by dump recipes to back up to Amazon S3 or Rackspace Cloud Files.",
  :required => "required",
  :choice => [ "S3", "CloudFiles" ],
  :recipes => [ "repo_test::default"]

attribute "repo_test/storage_account_id",
  :display_name => "Dump Storage Account ID",
  :description => "In order to write the dump file to the specified cloud storage location, you need to provide cloud authentication credentials. For Amazon S3, use your Amazon access key ID (e.g., cred:AWS_ACCESS_KEY_ID). For Rackspace Cloud Files, use your Rackspace login username (e.g., cred:RACKSPACE_USERNAME).",
  :required => "required",
  :recipes => [ "repo_test::default"]

attribute "repo_test/storage_account_secret",
  :display_name => "Dump Storage Account Secret",
  :description => "In order to write the dump file to the specified cloud storage location, you will need to provide cloud authentication credentials. For Amazon S3, use your AWS secret access key (e.g., cred:AWS_SECRET_ACCESS_KEY). For Rackspace Cloud Files, use your Rackspace account API key (e.g., cred:RACKSPACE_AUTH_KEY).",
  :required => "required",
  :recipes => [ "repo_test::default"]

attribute "repo_test/container",
  :display_name => "Dump Container",
  :description => "The cloud storage location where the dump file will be saved to or restored from. For Amazon S3, use the bucket name. For Rackspace Cloud Files, use the container name.",
  :required => "required",
  :recipes => [ "repo_test::default"]

attribute "repo_test/prefix",
  :display_name => "Dump Prefix",
  :description => "The prefix that will be used to name/locate the backup of a particular database dump. Defines the prefix of the dump file name that will be used to name the backup database dump file, along with a timestamp.",
  :required => "required",
  :recipes => [ "repo_test::default"]
