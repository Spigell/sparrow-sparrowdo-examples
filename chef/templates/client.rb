log_level              :info
log_location           STDOUT
ssl_verify_mode        :verify_none
chef_server_url        '[% host %]/organizations/[% org %]'
client_key             '/etc/chef/client.pem'
validation_key         '/etc/chef/validator.pem'
validation_client_name '[% org %]-validator'
