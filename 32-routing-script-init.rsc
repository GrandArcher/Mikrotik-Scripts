# Example Interface List
/interface list
add name=LAN-List comment="Interfaces monitored by arp-add-32-route"

/interface list member
add list=LAN-List interface=ether7

# Example Address List (you can add multiple subnets or individual IPs)
 /ip firewall address-list
add list=CLIENT-POOL address=100.64.99.0/24 comment="Pool for /32 routes"

# Create and set the Interface List name
:global arpScriptIfaceList "LAN-List"
:set arpScriptIfaceList "LAN-List"

# Create and set the Address List name
:global arpScriptAddrList "CLIENT-POOL"
:set arpScriptAddrList "CLIENT-POOL"


/system script
add name=arp-script-setup dont-require-permissions=no owner=admin policy=read,write,test source="\
:global arpScriptIfaceList \"LAN-List\"; \
:global arpScriptAddrList  \"CLIENT-POOL\"; \
:log info \"arp-script-setup: Global variables initialized (IfaceList=LAN-List | AddrList=CLIENT-POOL)\"; \
:put \"arp-script-setup finished successfully\" \
"

/system scheduler
add name=arp-script-init-startup interval=0s on-event="/system script run arp-script-setup" \
    start-time=startup policy=read,write,test
