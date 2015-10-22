#!/bin/bash
scp -p *.html ubuntu@vcair.us:/home/ubuntu/vcadevops/website
scp -rp ./docs ubuntu@vcair.us:/home/ubuntu/vcadevops/website/docs
scp -rp ./static/img  ubuntu@vcair.us:/home/ubuntu/vcadevops/website/static/img
scp -rp ./static/css  ubuntu@vcair.us:/home/ubuntu/vcadevops/website/static/css
