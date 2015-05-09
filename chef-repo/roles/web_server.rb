name "web_server"
description "A role to configure our front-line web servers"
run_list "recipe[apt]", "recipe[nginx]"
