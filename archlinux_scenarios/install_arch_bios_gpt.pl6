# systemctl start sshd 
# mount / -o remount,size=4G /run/archiso/cowspace
# pacman -Sy --noconfirm gcc make cpanminus && cpanm -n Sparrow
# passwd
# visudo 
# This is example for BIOS-GPT install.
# !!! WARNING. This example may wipe date from disk! 

my $disk = '/dev/sda';

task_run 'create gpt table force', 'disk-partitioner', %(
  table => %(
    type => 'gpt',
    target => "$disk",
    recreate => 'true'
  )
);

task_run 'make main ext4', 'disk-partitioner', %(
  partition => %(
    type => 'primary',
    target => "$disk",
    start  => '2Mib',
    end    => '9Gib',
	flags  => 'lvm',
  ),
);

task_run 'make boot partition', 'disk-partitioner', %(
  partition => %(
    target => "$disk",
    fs     => %(
      type => 'fat32',
      ),
    start  => '9Gib',
    end    => '9302Mib',
    flags  => ( 'bios_grub' )
  ),
);

task-run "create main lv", "lvm", %(
  action    => 'create',
  partition => '/dev/sda1',
  vg        => 'vg_main',
  lv        => 'slashroot',
  size      => '7GB',
  fs        => %(
    type => 'ext4'
  ),
);

task-run "create home lv", "lvm", %(
  action    => 'create',
  recreate  => 'true',
  partition => '/dev/sda1',
  vg        => 'vg_main',
  lv        => 'home',
  size      => '100M',
  fs        => %(
    type => 'ext2'
  ),
);

task-run "create spigell lv", "lvm", %(
  action    => 'create',
  recreate  => 'true',
  partition => '/dev/sda1',
  vg        => 'vg_main',
  lv        => 'spigell',
  size      => '500MB',
  fs        => %(
    type => 'ext4'
  )
);

task-run "Install Archlinux", "archlinux-install", %(
  hostname  => 'myArchlinux',
  rootpw    => 'koteika42',
  timezone  => 'Europe/Moscow',
  locales   => %(
    default  => 'ru_RU.UTF-8'
  ),
  mirrorlist => %(
    servers => ( 'http://mirror.yandex.ru/archlinux/$repo/os/$arch' ) 
  ),
  disk => %(
    lvm  => %( 
      vg   => 'vg_main',
      lv   => 'slashroot'
    ),
  ),
  bootloader => %( 
    grub   => %( 
      type      => 'bios',
      target    => '/dev/sda',
    ),
  ),
  packages => %(
    installed => ( 'openssh', 'sudo', 'networkmanager' )
  ),
  services => %(
    enabled => ( 'sshd', 'NetworkManager' )
  ),
);

# add my public ssh key because by default ssh's behavior doesn't accept access by root password.
directory '/mnt/root/.ssh', %(
    mode => '700'
 );  
 
file '/mnt/root/.ssh/authorized_keys', %(
    mode    => 600,
    content => '
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDT5MmfFDghhuf7GMSVEQvJXFap5oBXrRMqUfELioFzTkCPppCN8QzLaDjw6NaREjDO8RpAJzkTxlBL24xxIU518hAdqhz2jDN0po9Ml/0S2FiAlotfmDQRY3XonqrCRbd4uTHyCpjpWI2KsbP9yhP2NxP5zdI9zZptyf4uEfcF0Ng6tDNCGP49RRM3VlwbvuzbsS9VraZk1nlAeiRM3AOumgOMpNNMK3aCIpb/HIfLpRzgkQptwkM5Rn3qtRbHTKjE6IKFgT7EonLczfW3ToWO1MjO29M+k7/UBd6PsHhr9g2AxbTtTFSMw9J9RN/WiuWwG/nUY6UwjKj0ENnmngzT spigell@bebop'
);
