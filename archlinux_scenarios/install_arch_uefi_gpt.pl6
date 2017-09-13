# systemctl start sshd 
# mount / -o remount,size=4G /run/archiso/cowspace
# pacman -Sy --noconfirm gcc make cpanminus && cpanm -n Sparrow
# passwd
# visudo 
# This is example for UEFI-GPT install.
# !!! WARNING. This example may wipe date from disk! 

my $disk = '/dev/sda';



task_run 'create gpt table force', 'disk-partitioner', %(
  table => %(
    type => 'gpt',
    target => "$disk",
    recreate => 'true'
  )
);

task_run 'create main lvm', 'disk-partitioner', %(
  partition => %(
    target => "$disk",
    start  => '2M',
    end    => '15Gib',
	flags  => 'lvm'
  )
);

task_run 'create boot partition', 'disk-partitioner', %(
  partition => %(
    target => "$disk",
    start  => '15Gib',
    end    => '16000Mib',
	flags  => 'boot'
  )
);
task-run "create main lv", "lvm", %(
  action    => 'create',
  partition => '/dev/sda1',
  vg        => 'vg_main',
  lv        => 'slashroot',
  size      => '7GB'
);

task-run "Install Archlinux", "archlinux-install", %(
  system => %(
    hostname  => 'myArchlinux',
    root-pass => 'koteika42',
  ),
  disk => %(
    lvm  => %( 
      vg   => 'vg_main',
      lv   => 'slashroot'
    ),
  ),
  bootloader => %( 
    grub   => %( 
      install   => 'true',
      type      => 'efi',
      target    => '/dev/sda',
      partition => '/dev/sda2',
    ),
  ),
  postinstall => %(
    packages        => ('openssh sudo networkmanager git '),
    enable-services => ('sshd NetworkManager dhcpcd')
  )
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

