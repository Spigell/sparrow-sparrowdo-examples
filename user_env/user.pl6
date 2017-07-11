my $user  = 'spigell';

package-install ('git', 'htop');

task-run "create user $user", 'user', %(
  action   => 'create',
  name     => "$user",
  home_dir => "/home/$user",
  groups   => 'wheel',
  password => '12345',
);

task-run 'some configs', 'get-remote-files', %(
  file1 => %(
    target      => "https://raw.githubusercontent.com/Spigell/configs-vim/master/vimrc",
    destination => "/home/$user/.vimrc"
  ),
  file2 => %(
    target      => "https://raw.githubusercontent.com/Spigell/configs-git/master/gitconfig",
    destination => "/home/$user/.gitconfig"
  ),
  file3 => %(
    target      => "https://raw.githubusercontent.com/Spigell/configs-bash/master/bashrc",
    destination => "/home/$user/.bashrc"
  ),
);

# SSH keys
directory "/home/$user/.ssh", %(
  action => 'create',
  mode => 700,
  owner => "$user", 
  )
;

task-run 'my key', 'get-remote-files', %(
  file1 => %(
    target      => "https://github.com/spigell.keys",
    destination => "/home/$user/.ssh/authorized_keys"
  ),
);
file "/home/$user/.ssh/authorized_keys", %(
  action  => 'create',
  owner   => "$user",
  mode    => 600,
);
