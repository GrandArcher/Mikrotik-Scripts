/system script
add dont-require-permissions=no name=arp-add-32-route owner=admin policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source=":l\
    ocal iface \"ether7\"; :local pool \"100.64.99.0/24\"; :local currentARPs [\
    /ip arp find where interface=\$iface and address in \$pool and dynamic and \
    complete]; :foreach arpId in=\$currentARPs do={ :local ip [/ip arp get \$ar\
    pId address]; :local mac [/ip arp get \$arpId mac-address]; :local routeCom\
    ment (\"ARP32-\" . \$mac); :if ([/ip route find where dst-address=(\$ip . \
    \"/32\") and comment=\$routeComment] = \"\") do={ /ip route add dst-address\
    =(\$ip . \"/32\") gateway=\$iface scope=10 target-scope=10 comment=\$routeC\
    omment; :log info (\"Added /32 route for ARP: \" . \$ip . \" (MAC: \" . \$m\
    ac . \")\") } }"
