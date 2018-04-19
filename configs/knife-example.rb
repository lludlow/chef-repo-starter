# See https://docs.getchef.com/config_rb_knife.html for more information on knife configuration options

current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
node_name                "your_username"
client_key               "#{current_dir}/your_key.pem"
validation_client_name   "example_org-validator"
validation_key           "#{current_dir}/example_org-validator.pem" # Can be found in 1password
chef_server_url          "https://chef.example.com/organizations/example_org"
cookbook_path            ["#{current_dir}/../cookbooks"]
