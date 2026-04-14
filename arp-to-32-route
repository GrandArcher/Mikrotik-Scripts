/system script
add dont-require-permissions=no name=arp-to-32-route owner=admin policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source=":l\
    ocal iface \"ether7\"; :local pool \"100.64.99.0/24\"; :local currentARPs [\
    /ip arp find where interface=\$iface and address in \$pool and dynamic and \
    complete]; :foreach arpId in=\$currentARPs do={ :local ip [/ip arp get \$ar\
    pId address]; :local mac [/ip arp get \$arpId mac-address]; :local routeCom\
    ment (\"ARP32-\" . \$mac); :if ([/ip route find where dst-address=(\$ip . \
    \"/32\") and comment=\$routeComment] = \"\") do={ /ip route add dst-address\
    =(\$ip . \"/32\") gateway=\$iface scope=10 target-scope=10 comment=\$routeC\
    omment; :log info (\"Added /32 route for ARP: \" . \$ip . \" (MAC: \" . \$m\
    ac . \")\") } }; :local existingRoutes [/ip route find where comment~\"ARP3\
    2-\" and dst-address in \$pool]; :foreach routeId in=\$existingRoutes do={ \
    :local routeIP [/ip route get \$routeId dst-address]; :local cleanIP [:pick\
    \_\$routeIP 0 [:find \$routeIP \"/\"]]; :local routeMAC [:pick [/ip route g\
    et \$routeId comment] 6 999]; :if ([/ip arp find where address=\$cleanIP an\
    d interface=\$iface and mac-address=\$routeMAC and complete] = \"\") do={ /\
    ip route remove \$routeId; :log info (\"Removed stale /32 route for: \" . \
    \$cleanIP) } }"
