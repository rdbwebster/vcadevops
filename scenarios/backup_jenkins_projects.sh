cd /tmp
wget http://vcair.us:8100/jnlpJars/jenkins-cli.jar
cd -

#java -jar mp/jenkins-cli.jar -s http://vcair.us:8100/ help --username jenkins --password devops123

# create_photon
java -jar /tmp/jenkins-cli.jar -s http://vcair.us:8100/ get-job create_photon --username jenkins --password $PASSWORD  > ./createPhoton/jenkins/config.xml

# create_ubuntu
java -jar /tmp/jenkins-cli.jar -s http://vcair.us:8100/ get-job create_ubuntu --username jenkins --password $PASSWORD > ./createUbuntu/jenkins/config.xml

# docker_photon
java -jar /tmp/jenkins-cli.jar -s http://vcair.us:8100/ get-job docker_photon --username jenkins --password $PASSWORD  > ./dockerPhoton/jenkins/config.xml

# spring_boot_form
java -jar /tmp/jenkins-cli.jar -s http://vcair.us:8100/ get-job spring_boot_form  --username jenkins --password $PASSWORD  > ./springFormSubmission/jenkins/config.xml

# web_server
java -jar /tmp/jenkins-cli.jar -s http://vcair.us:8100/ get-job web_server   --username jenkins --password $PASSWORD > ./webServer/jenkins/config.xml

# Chef_Knife
java -jar /tmp/jenkins-cli.jar -s http://vcair.us:8100/ get-job Chef_Knife   --username jenkins --password $PASSWORD > ./chefKnife/jenkins/config.xml

# reset_demo
java -jar /tmp/jenkins-cli.jar -s http://vcair.us:8100/ get-job reset_demo  --username jenkins --password $PASSWORD > ./resetDemo/jenkins/config.xml

# Word Findfer
java -jar /tmp/jenkins-cli.jar -s http://vcair.us:8100/ get-job word_finder  --username jenkins --password $PASSWORD > ./wordFinder/jenkins/config.xml

