#!/bin/zsh

# ask user to give value to variables

# the project title
read -p "# ENTER THE PROJECT TITLE: " project

# the project path
read -p "# WHERE TO PUT THE PROJECT: " path

# the project owner (member of groups _www on mac or www-data on linux)
read -p "# WHO OWNS THE PROJECT: " owner



# get wordpress, unpack, rename and remove zip
wget https://wordpress.org/latest.zip && unzip latest.zip && mv wordpress $path/$project && rm -rf latest.zip

# create empty db for wordpress *have to figure this out*

# get .htaccess
wget https://raw.githubusercontent.com/thisbit/myhtaccess/master/.htaccess && mv ./.htaccess ./$project/.htaccess

# get humans.txt
wget https://raw.githubusercontent.com/thisbit/humans/master/humans.txt && mv ./humans.txt ./$project/humans.txt

# get robots.txt
wget https://raw.githubusercontent.com/thisbit/robots/master/robots.txt && mv ./robots.txt ./$project/robots.txt

# remove stock themes
rm -r ./$project/wp-content/themes/*/

# remove stock plugins, but leave index.php
rm -r ./$project/wp-content/plugins/*/ && find ./$project/wp-content/plugins/ -type f -not -name "index.php" -delete

# get wprig, unpack and remove zip
wget https://github.com/wprig/wprig/archive/master.zip && unzip master.zip && mv wprig-master ./$project/wp-content/themes/wprig && rm -rf master.zip

# get js dependencies with gulpfile (I think composer needs to be global on machine)

# get db-migrate, unpack and remove zip
wget https://github.com/deliciousbrains/wp-migrate-db/archive/master.zip && unzip master.zip -d ./$project/wp-content/plugins/ && rm -rf master.zip

# get show current template, unpack and remove zip
wget https://github.com/tekapo/show-current-template/archive/master.zip && unzip master.zip -d ./$project/wp-content/plugins/ && rm -rf master.zip

# get classic editor, unpack and remove zip
wget https://github.com/WordPress/classic-editor/archive/master.zip && unzip master.zip -d ./$project/wp-content/plugins/ && rm -rf master.zip

# chown it with user that is part of group www-data or _www (on mac)
sudo chown -R $owner $project
