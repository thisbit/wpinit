#!/bin/bash
# ASK FOR USER INPUT
	# WARNING
		echo  "# WARNING: run this in your webroot!"
	# the project title
		read -p "# PROJECT TITLE: " project

	# the project owner (member of groups _www on mac or www-data on linux)
		read -p "# USER (local sudo user): " owner

	# the db password
		read -p "# PASSWORD (for wp and mysql to use): " pass

		read -p "# CHOOSE THEME (write number):
		(1) wprig (starter theme with build processes, linting etc),
		(2) _s underscores (simple starter theme),
		(3) understrap (_s with bootstrap),
		(4) enfold (commercial theme with blockeditor, a parent theme)
		: " theme

	# open in browser (firefox, chromium, opera, qutebrowser):
		read -p "# YOUR BROWSER (firefox, chromium, opera, qutebrowser): " browser

	# choose one editor (subl, atom, code):
		read -p "# YOUR EDITOR (subl, atom, code): " editor

# SET WP
	# get wordpress
		wget https://wordpress.org/latest.zip
		unzip latest.zip
		mv wordpress ./$project
		rm -rf latest.zip
​
	# wp-config
​
		# saltkeys
			# get saltkeys
			grep -A 1 -B 50 'since 2.6.0' ./$project/wp-config-sample.php > ./$project/wp-config.php
			wget -O - https://api.wordpress.org/secret-key/1.1/salt/ >> ./$project/wp-config.php
			grep -A 50 -B 3 'Table prefix' ./$project/wp-config-sample.php >> ./$project/wp-config.php
​
			# db info
				sed -i.tmp "s/database_name_here/$project/;s/username_here/$owner/;s/password_here/$pass/;s/wp_/wpstroj_/" ./$project/wp-config.php
			# clean-up tmp files
				rm ./$project/*.tmp
​
	# get .htaccess
		wget https://raw.githubusercontent.com/thisbit/myhtaccess/master/.htaccess
		mv ./.htaccess ./$project/htaccess
	# get humans.txt
		wget https://raw.githubusercontent.com/thisbit/humans/master/humans.txt
		mv ./humans.txt ./$project/humans.txt
	# get robots.txt
		wget https://raw.githubusercontent.com/thisbit/robots/master/robots.txt
		mv ./robots.txt ./$project/robots.txt
	# remove stock themes
		rm -r ./$project/wp-content/themes/*/
	# remove stock plugins (but leave index.php)
		rm -r ./$project/wp-content/plugins/*/
		find ./$project/wp-content/plugins/ -type f -not -name "index.php" -delete
​
# SET PLUGINS
	# db-migrate
		wget https://github.com/deliciousbrains/wp-migrate-db/archive/master.zip
		unzip master.zip -d ./$project/wp-content/plugins/
		rm -rf master.zip
	# show current template
		wget https://github.com/tekapo/show-current-template/archive/master.zip
		unzip master.zip -d ./$project/wp-content/plugins/
		rm -rf master.zip
	# classic editor
		wget https://github.com/WordPress/classic-editor/archive/master.zip
		unzip master.zip -d ./$project/wp-content/plugins/
		rm -rf master.zip
	# duplicate page
		wget https://github.com/WPPlugins/duplicate-page/archive/master.zip
		unzip master.zip -d ./$project/wp-content/plugins/
		rm -rf master.zip
	# Yoast SEO
		wget https://github.com/Yoast/wordpress-seo/archive/trunk.zip
		unzip trunk.zip -d ./$project/wp-content/plugins/
		rm -rf trunk.zip
	# Loginizer (lightweight security)
		wget -r -np -R "index.html*" http://plugins.svn.wordpress.org/loginizer/trunk/
		cp -r ./plugins.svn.wordpress.org/loginizer/trunk ./$project/wp-content/plugins/loginizer
		rm -rf ./plugins.svn.wordpress.org
​
	# Cerber (hardweight security)
		wget https://github.com/WPPlugins/wp-cerber/archive/master.zip
		unzip master.zip -d ./$project/wp-content/plugins/
		rm -rf master.zip

# SET THEME
	enfold_child_css_header="/*
	Theme Name: project
	Author: thisbit
	Template: enfold
	Author URI: https://github.com/thisbit/
	Description: Lorem Ipsum
	Version: 1.0
	Text Domain: project_
	Tags: lorem, ipsum
	*/
	"

	if [[ $theme = "1" ]]
		then
		wget https://github.com/wprig/wprig/archive/master.zip
		unzip master.zip
		mv wprig-master ./$project/wp-content/themes/wprig-$project
		rm -rf master.zip
	elif [ $theme = "2" ]
		then
		wget https://github.com/Automattic/_s/archive/master.zip
		unzip master.zip
		mv _s-master ./$project/wp-content/themes/_s-$project
		rm -rf master.zip
		# see if you can automate string replacement "_s" with "$project"
	elif [ $theme = "3" ]
		then
		wget https://github.com/understrap/understrap/archive/master.zip
		unzip master.zip
		mv understrap-master ./$project/wp-content/themes/understrap-$project
	elif [ $theme = "4" ]
		then
		unzip /home/ek/serv/enfold-2020/enfold.zip -d ./$project/wp-content/themes/
		mkdir ./$project/wp-content/themes/enfold-child/
		echo "$enfold_child_css_header" > ./$project/wp-content/themes/enfold-child/styles.css
		sed -i "s/project/$project/g" ./$project/wp-content/themes/enfold-child/styles.css
	else
		echo "ERROR, you failed to choose an available theme!"
		exit
	fi
	echo "theme successfully installed"

# FIX PROJECT PREFERENCES (with user that is part of group www-data or _www (on mac))
	sudo chown -Rf www-data:www-data ./$project
	sudo chmod -R 777 ./$project

# CREATE EMPTY DATABASE, use same name in wp-config
	sudo mysql -u$owner -p$pass -e "CREATE DATABASE $project"

# create sites .conf file
	# set a variable to hold content for the apache config file
	TEMPLATE="<VirtualHost *:80>
    ServerName template.stroj
    ServerAlias www.template.stroj
    ServerAdmin webmaster@template.stroj
    DocumentRoot /home/ek/serv/template

    <Directory /home/ek/serv/template>
        Options -Indexes +FollowSymLinks
        AllowOverride All
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/template.stroj-error.log
    CustomLog ${APACHE_LOG_DIR}/template.stroj-access.log combined
</VirtualHost>"
	# pipe variable output to sed and save modified outputin to file
	echo "$TEMPLATE" | sudo sed s/template/$project/g > /etc/apache2/sites-available/$project.stroj.conf

# create symlink in sites-enabled
	sudo ln -s /etc/apache2/sites-available/$project.stroj.conf /etc/apache2/sites-enabled

# add redirect to hosts
	sudo -- sh -c "echo '\n'127.0.1.1\ $project.stroj >> /etc/hosts"

# reboot apache (agnostic for all linux/unix)
	sudo apachectl -k graceful

# open project in firefox
	$browser $project.stroj

# open theme project in editor
	$editor ./$project/wp-content
