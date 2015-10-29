cd /tmp
wget http://vcair.us:8100/jnlpJars/jenkins-cli.jar
cd -

#java -jar /tmp/jenkins-cli.jar -s http://vcair.us:8100/ help --username admin --password $PASSWORD

# create_ubuntu
java -jar /tmp/jenkins-cli.jar -s http://vcair.us:8100/ get-job create_ubuntu --username admin --password $PASSWORD > ./createUbuntu/jenkins/config.xml

# docker_photon
java -jar /tmp/jenkins-cli.jar -s http://vcair.us:8100/ get-job docker_photon --username admin --password $PASSWORD  > ./dockerPhoton/jenkins/config.xml

# spring_boot_form
java -jar /tmp/jenkins-cli.jar -s http://vcair.us:8100/ get-job spring_boot_form  --username admin --password $PASSWORD  > ./springFormSubmission/jenkins/config.xml

# web_server
java -jar /tmp/jenkins-cli.jar -s http://vcair.us:8100/ get-job web_server   --username admin --password $PASSWORD > ./webServer/jenkins/config.xml

# reset_demo
java -jar /tmp/jenkins-cli.jar -s http://vcair.us:8100/ get-job reset_demo  --username admin --password $PASSWORD > ./resetDemo/jenkins/config.xml

# Word Findfer
java -jar /tmp/jenkins-cli.jar -s http://vcair.us:8100/ get-job word_finder  --username admin --password $PASSWORD > ./wordFinder/jenkins/config.xml

