
cd /tmp
wget http://localhost:8100/jnlpJars/jenkins-cli.jar

# create_photon
java -jar /tmp/jenkins-cli.jar -s http://localhost:8100/ get-job create_photon > /home/ubuntu/vcadevops/scenarios/createPhoton/create_photon_config.xml

# create_ubuntu
java -jar /tmp/jenkins-cli.jar -s http://localhost:8100/ get-job create_ubuntu > /home/ubuntu/vcadevops/scenarios/createUbuntu/config.xml

# docker_photon
java -jar /tmp/jenkins-cli.jar -s http://localhost:8100/ get-job docker_photon  > /home/ubuntu/vcadevops/scenarios/dockerPhoton/docker_photon_config.xml

# spring_boot_form
java -jar /tmp/jenkins-cli.jar -s http://localhost:8100/ get-job spring_boot_form  > /home/ubuntu/vcadevops/scenarios/springFormSubmission/jenkins/config.xml

# web_server
java -jar /tmp/jenkins-cli.jar -s http://localhost:8100/ get-job web_server  > /home/ubuntu/vcadevops/scenarios/webServer/web_server_config.xml

# Chef_Knife
java -jar /tmp/jenkins-cli.jar -s http://localhost:8100/ get-job Chef_Knife  > /home/ubuntu/vcadevops/scenarios/chefKnife/jenkins/chef_knife_config.xml

# reset_demo
java -jar /tmp/jenkins-cli.jar -s http://localhost:8100/ get-job reset_demo  > /home/ubuntu/vcadevops/scenarios/resetDemo/jenkins/resetDemo_config.xml

