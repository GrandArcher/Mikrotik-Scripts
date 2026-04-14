/system script
add dont-require-permissions=no name=arp-remove-32-route owner=admin policy=\
    ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source=":l\
    ocal iface \"ether7\"; :local pool \"100.64.99.0/24\"; :local existingRoute\
    s [/ip route find where comment~\"ARP32-\" and dst-address in \$pool]; :for\
    each routeId in=\$existingRoutes do={ :local routeIP [/ip route get \$route\
    Id dst-address]; :local cleanIP [:pick \$routeIP 0 [:find \$routeIP \"/\"]]\
    ; :local missFile (\"/arp-miss-\" . \$cleanIP . \".txt\"); :local arpComple\
    te [/ip arp find where address=\$cleanIP and interface=\$iface and complete\
    ]; :if (\$arpComplete = \"\") do={ :local missCount 0; :if ([/file find nam\
    e=\$missFile] != \"\") do={ :set missCount [:tonum [/file get [find name=\$\
    missFile] contents]] }; :set missCount (\$missCount + 1); /file set [find n\
    ame=\$missFile] contents=\$missCount; :if (\$missCount >= 3) do={ /ip route\
    \_remove \$routeId; /file remove [find name=\$missFile]; :log info (\"Remov\
    ed /32 route after exactly 3 runs: \" . \$cleanIP) } } else={ :if ([/file f\
    ind name=\$missFile] != \"\") do={ /file remove [find name=\$missFile] } } \
    }"
