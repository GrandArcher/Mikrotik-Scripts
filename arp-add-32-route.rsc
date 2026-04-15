/system script set arp-add-32-route source="\
:local ifaceList \"LAN-List\"; \
:local addrList  \"CLIENT-POOL\"; \
\
:local ifaceMembers [/interface list member find list=\$ifaceList]; \
\
:foreach memberId in=\$ifaceMembers do={ \
    :local currentIface [/interface list member get \$memberId interface]; \
    \
    :log info (\"Scanning interface: \" . \$currentIface); \
    \
    :local currentARPs [/ip arp find where dynamic and interface=\$currentIface]; \
    \
    :foreach arpId in=\$currentARPs do={ \
        :local ip  [/ip arp get \$arpId address]; \
        :local mac [/ip arp get \$arpId mac-address]; \
        \
        :if (\$mac = \"\") do={ :continue }; \
        \
        :if ([/ip firewall address-list find list=\$addrList and \$ip in address] != \"\") do={ \
            :local routeComment (\"ARP32-\" . \$mac); \
            :local dst (\$ip . \"/32\"); \
            \
            :local routeId [/ip route find where dst-address=\$dst]; \
            \
            :if (\$routeId = \"\") do={ \
                /ip route add dst-address=\$dst gateway=\$currentIface scope=10 target-scope=10 comment=\$routeComment; \
                :log info (\"Added /32 route for ARP: \" . \$ip . \" (MAC: \" . \$mac . \") via \" . \$currentIface); \
            } else={ \
                :local existingGw [/ip route get \$routeId gateway]; \
                :local existingComment [/ip route get \$routeId comment]; \
                \
                :if (\$existingGw != \$currentIface) do={ \
                    :log warning (\"WARNING: Route for \" . \$ip . \" has wrong gateway: \" . \$existingGw); \
                } else={ \
                    :if (\$existingComment != \$routeComment) do={ \
                        /ip route set \$routeId comment=\$routeComment; \
                        :log info (\"Updated comment for \" . \$ip); \
                    }; \
                }; \
            }; \
        }; \
    }; \
}; \
:log info \"arp-add-32-route: Scan finished for interface list \$ifaceList\" \
"
