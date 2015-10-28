#!/bin/bash
scp -i ~/.ssh/ubuntu_rsa -rp *.html ubuntu@vcair.us:/home/ubuntu/vcadevops/website
scp -i ~/.ssh/ubuntu_rsa -rp ./docs ubuntu@vcair.us:/home/ubuntu/vcadevops/website/docs
scp -i ~/.ssh/ubuntu_rsa -rp ./static/img  ubuntu@vcair.us:/home/ubuntu/vcadevops/website/static/img
scp -i ~/.ssh/ubuntu_rsa -rp ./static/css  ubuntu@vcair.us:/home/ubuntu/vcadevops/website/static/css
