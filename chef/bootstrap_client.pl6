my $server = 'https://127.0.0.1';
my $org = 'tomato';

my $target = 'https://packages.chef.io/files/stable/chef/13.2.20/el/7/chef-13.2.20-1.el7.x86_64.rpm';
my $destination_dir = '/tmp/';


task-run 'install client', 'get-remote-files', %(
  file1 => %(
    target => "$target",
    destination => "$destination_dir/chef-client.rpm"
  )
);

bash "cd $destination_dir && sudo yum install -y chef-client.rpm";

directory '/etc/chef';

file '/etc/chef/validator.pem', %(
   content => (slurp 'data/validator.pem') 
);

template '/etc/chef/client.rb', %(
  source => ( slurp 'templates/client.rb' ),
  variables => %(
    host => "$server",
    org  => "$org",
   ),
);
