The website folder contains the content necessary for a website to be presented by nginx.

It is designed to not require server side processing, so that the content can be edited at a remote workstation using a app like Seamonkey.
Headers etc are include client side using jquery.

The site html and image can be edited at a remote desktop and synced to the vcair.us site using scp.
The upload.sh command will upload all content to the site so changes to code can be seen.

The website code is maintained in github and can be pushed from a client workstation or the vcair site.
to avoid conflicts it is probably best to just edit the html on the desktop and use upload.sh to modify the site and do git push from the client workstation as well.

If the vcair site for some reason needs to sync with github a git pull can be performed to sync the site with the repo.

The original website used flask with its internal web server, but the embedded template macros for service side includes  made it difficult 
to edit html content remotely as server side commands would not run and would appear as non html markup.

An nginx server to host the site can be installed on ubuntu using this command:

$ sudo apt-get install nginx

After installation the default config must be changed so that the html root points to /home/ubuntu/vcadevops/website

// disable default site since uses /usr/share/nginx/www for files
$ sudo rm /etc/nginx/sites-enabled/default

// add a new site for vcadevops based on the default site
$ cd /etc/nginx/
$ sudo cp sites-available/default sites-available/devopsui 

// edit to match the sample file below 
// Basically change root value and add a location for /labs/.

$ sudo vi sites-available/devopsui
 
server {
        listen   80; ## listen for ipv4; this line is default and implied
        #listen   [::]:80 default ipv6only=on; ## listen for ipv6

        root /home/ubuntu/vcadevops/website;
        index index.html index.htm;

        # Make site accessible from http://localhost/
        #server_name localhost;

        location / {
                # First attempt to serve request as file, then
                # as directory, then fall back to index.html
                try_files $uri $uri/ /index.html;
                # Uncomment to enable naxsi on this location
                # include /etc/nginx/naxsi.rules
        }

        location /labs/ {
                try_files $uri $uri/ /index.html;
        }

        location /docs/ {
                try_files $uri $uri/ /index.html;
        }


// next add sym link to enable the devopsui site
sudo ln -s /etc/nginx/sites-available/devopsui  /etc/nginx/sites-enabled/devopsui

// Retart nginx

sudo nginx -s reload

or 

sudo service nginx resart


// access site at

http://vcair.us

