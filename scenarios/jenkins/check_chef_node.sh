# This script checks if a server (node) is registered with the chef server
# and with the correct ip
# This is necessary since the demo environment will create new servers,
# the first time the demo is run and demos resets where generated servers have been removed..

if [ "$#" -ne 2 ];
    then echo "Usage: check_chef_node server ip"
    exit
fi

# See if the server is registered with the chef-server
if [ $(knife node list | grep "$1" | wc -l) -gt 0 ]
then
   # Registered, See if the Server is registered with Chef-Server using the same IP
   export NIP=`knife node show $1 | grep IP: | cut -d: -f2 | sed -e 's/^[[:space:]]*//'`
   if [ "$NIP" != "$2" ]
   then
    # Registered but with wrong (old) ip
    echo "=> Removing old node registration from chef-server"
    knife node delete $1  --yes
    echo "=> Bootstrap the server to install the client, register and set the run list"
    knife bootstrap $2 -x ubuntu --sudo --run-list  'recipe[SB1]'
   else
      echo "=> Node correctly registered with Chef Server"
   fi
# Not registered
else
   echo "=> Bootstrap the server to install the client, register and set the run list"
   knife bootstrap $2 -x ubuntu --sudo --run-list  'recipe[SB1]'
fi
