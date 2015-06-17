
#cd /tmp
#wget http://localhost:8100/jnlpJars/jenkins-cli.jar

#java -jar /tmp/jenkins-cli.jar -s http://localhost:8100/ help --username jenkins --password devops123

# create_photon
java -jar /tmp/jenkins-cli.jar -s http://localhost:8100/ get-job create_photon --username jenkins --password $PASSWORD  > /home/ubuntu/vcadevops/scenarios/createPhoton/jenkins/config.xml

# create_ubuntu
java -jar /tmp/jenkins-cli.jar -s http://localhost:8100/ get-job create_ubuntu --username jenkins --password $PASSWORD > /home/ubuntu/vcadevops/scenarios/createUbuntu/jenkins/config.xml

# docker_photon
java -jar /tmp/jenkins-cli.jar -s http://localhost:8100/ get-job docker_photon --username jenkins --password $PASSWORD  > /home/ubuntu/vcadevops/scenarios/dockerPhoton/jenkins/config.xml

# spring_boot_form
java -jar /tmp/jenkins-cli.jar -s http://localhost:8100/ get-job spring_boot_form  --username jenkins --password $PASSWORD  > /home/ubuntu/vcadevops/scenarios/springFormSubmission/jenkins/config.xml

# web_server
java -jar /tmp/jenkins-cli.jar -s http://localhost:8100/ get-job web_server   --username jenkins --password $PASSWORD > /home/ubuntu/vcadevops/scenarios/webServer/jenkins/config.xml

# Chef_Knife
java -jar /tmp/jenkins-cli.jar -s http://localhost:8100/ get-job Chef_Knife   --username jenkins --password $PASSWORD > /home/ubuntu/vcadevops/scenarios/chefKnife/jenkins/config.xml

# reset_demo
java -jar /tmp/jenkins-cli.jar -s http://localhost:8100/ get-job reset_demo  --username jenkins --password $PASSWORD > /home/ubuntu/vcadevops/scenarios/resetDemo/jenkins/config.xml

