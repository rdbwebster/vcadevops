if [ -z ${devops_server_ip+x} ]; then
    echo "devops_server_ip must be set as environment variable"
    echo "It would have been set if provision.sh was run, in this case it must be set manually"
    exit;
fi

ansible-playbook  -vvvv playbook_devopsServer.yml -i hosts -u ubuntu --private-key   ~/.ssh/ubuntu_rsa  --sudo
