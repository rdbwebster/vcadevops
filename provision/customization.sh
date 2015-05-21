#!/bin/bash 
  echo performing customization tasks with param $1 at `date "+DATE: %Y-%m-%d - TIME: %H:%M:%S"` >> /root/customization.log 
  if [ x$1=x"precustomization" ]; 
  then 
    echo performing precustomization tasks on `date "+DATE: %Y-%m-%d - TIME: %H:%M:%S"`
    echo performing precustomization tasks on `date "+DATE: %Y-%m-%d - TIME: %H:%M:%S"` >> /root/customization.log
  fi 
  if [ x$1=x"postcustomization" ]; 
  then 
    echo performing postcustomization tasks at `date "+DATE: %Y-%m-%d - TIME: %H:%M:%S"`
    mkdir -p /home/ubuntu/.ssh

    printf "nameserver 8.8.8.8" >> /etc/resolvconf/resolv.conf.d/base

    echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDnD0tFDxOGD9O9gcaXD/2g1btxqjww8g6aPoc4RumbqwAvR4EYDQXkPrL08xGcLZttieSf+c3q6ZL4Vu7cDg+79/lbtZFk4f552+syhz27NUzPUMcSIdTL4PjDJv523WV6C+Jen9BadwhkyxwcQhU3nmwjkv+euHrxk03PtSiEBJTNMgQdsxw4fndA/9Pqh2TSShRUtEIbY35wQt0mxpvomANLTtR2nxuzWS1GQY69um0mR26++x33E5ylQOr2eiJO++73V+IZxgjRY06vQSUKZGc64H3BJlX2BKmABbV3sVji82mmkDyFK3yX538WRwUbvmuGSbVfiyKTIs7UK21f bwebster@bwebster-mbpro.local' >> /home/ubuntu/.ssh/authorized_keys

    chown ubuntu.ubuntu /home/ubuntu/.ssh
    chown ubuntu.ubuntu /home/ubuntu/.ssh/authorized_keys
    chmod go-rwx /home/ubuntu/.ssh
    chmod go-rwx /home/ubuntu/.ssh/authorized_keys

    echo performing postcustomization tasks at `date "+DATE: %Y-%m-%d - TIME: %H:%M:%S"` >> /root/customization.log 
  fi 

