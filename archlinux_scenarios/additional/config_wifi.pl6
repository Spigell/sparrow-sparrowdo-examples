package-install ('networkmanager', 'network-manager-applet');

service-start ('NetworkManager');
service-enable ('NetworkManager');

bash 'nmcli dev wifi connect TESTO password "12345"';
