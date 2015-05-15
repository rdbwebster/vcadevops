
if [ "$#" -ne 2 ];
    then echo "Usage: wait_boot_ip  vapp_name  vm_name"
    exit
fi

# get the new vm ip 
for a in 1 2 3 4 5 6 7 8 9; do
     export IP=`vca vm -a $1 | grep $2 | cut -d '|' -f5 |  tr -d '[[:space:]]'`
  
     echo "Obtain IP attempt $a"
     if [ ${#IP} -gt 1 ]
     then
       echo "New VM at $IP"
       break
     else
       sleep 10
     fi
done

echo ${IP}
