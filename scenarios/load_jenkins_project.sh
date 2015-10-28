#!/bin/bash

if [ $# -ne 2 ]; then
    echo $0: usage: load_jenkins_project name path/config.xml
    exit 1
fi

java -jar /tmp/jenkins-cli.jar -s http://vcair.us:8100/ create-job $1 --username admin --password $PASSWORD  < $2
