if [ "$#" -ne 3 ];
    then echo "Usage: map_url_port listen_port target_ip target_port"
    exit
fi

# Remove old port mapping if present, need new rule as ip may have changed for new server
export count=`sudo iptables -t nat -L PREROUTING -n --line-numbers | grep :${1} | wc -l`
while [ $count -gt 0 ]
do
  export rule=`sudo iptables -t nat -L PREROUTING -n --line-numbers | grep :${1}`
  sudo iptables -t nat -D PREROUTING `echo ${rule} | cut -d' ' -f1`
  count=`sudo iptables -t nat -L PREROUTING -n --line-numbers | grep :${1} | wc -l`
done

# create a port mapping to the app 
sudo iptables -t nat -A PREROUTING -i eth0 -p tcp --dport ${1} -m conntrack --ctstate NEW -j DNAT --to ${2}:${3}
