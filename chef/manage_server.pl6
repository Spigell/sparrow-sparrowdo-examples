my $target = 'https://packages.chef.io/files/stable/chef-server/12.15.8/el/7/chef-server-core-12.15.8-1.el7.x86_64.rpm';
my $destination_dir = '/tmp/';


task-run 'download server', 'get-remote-files', %(
  file1 => %(
    target => "$target",
    destination => "$destination_dir/chef-server.rpm"
  )
);

bash "cd /$destination_dir/ && sudo yum -y install chef-server.rpm && rm -rf chef-server.rpm";

bash 'chef-server-ctl reconfigure';

bash 'chef-server-ctl org-create tomato "Tomatonetwork"';

module_run 'Chef::Manager', %(
  action    => 'create-user',
  user-id   => 'spigell',
  email     => 'spigell@tomatonetwork.com',
  name      => 'Spigell',
  last-name => '7 Th',
  password  => '12345',
  org       => 'tomato'
);
