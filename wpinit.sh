#!/bin/bash
# ASK FOR VARIABLES
	# the project title
		read -p "# ENTER THE PROJECT TITLE: " project
	# the project path
		read -p "# WHERE TO PUT THE PROJECT: " path
	# the project owner (member of groups _www on mac or www-data on linux)
		read -p "# WHO OWNS THE PROJECT (local sudo user): " owner
	# the db name
		read -p "# ENTER THE DATABASE NAME : " dbname
	# the db user
		read -p "# ENTER THE DATABASE USER (for wp to use): " dbuser
	# the db password
		read -p "# ENTER THE DATABASE PASSWORD (for wp to use): " dbpass
	# the db prefix
		read -p "# ENTER THE DATABASE PREFIX (for wp to use): " dbpref
	# the mysql user
		read -p "# ENTER THE MYSQL USERNAME (pre-exhisting with createdb priviledges): " mysqlusr
		# the mysql password
		read -p "# ENTER THE MYSQL PASSWORD (for createdb priviledges): " mysqlpwd


# SET WP
	# get wordpress
		wget https://wordpress.org/latest.zip
		unzip latest.zip
		mv wordpress $path/$project
		rm -rf latest.zip
​	
	# wp-config
​
		# saltkeys
			# get saltkeys
				# wget https://api.wordpress.org/secret-key/1.1/salt/ -O ./$project/keys.tmp
			#write saltkeys into wp-config
				# sed -i.tmp "49,56d" ./$project/wp-config.php
				# sed -i.tmp "1d;48r ./$project/keys.tmp" ./$project/wp-config.php
			# clean-up tmp files
				# rm ./$project/*.tmp
​
			grep -A 1 -B 50 'since 2.6.0' ./$project/wp-config-sample.php > ./$project/wp-config.php
			wget -O - https://api.wordpress.org/secret-key/1.1/salt/ >> ./$project/wp-config.php
			grep -A 50 -B 3 'Table prefix' ./$project/wp-config-sample.php >> ./$project/wp-config.php
​
			# db info
				sed -i.tmp "s/database_name_here/$dbname/;s/username_here/$dbuser/;s/password_here/$dbpass/;s/wp_/$dbpref/" ./$project/wp-config.php
			# clean-up tmp files
				rm ./$project/*.tmp
​
	# get .htaccess
		wget https://raw.githubusercontent.com/thisbit/myhtaccess/master/.htaccess
		mv ./.htaccess ./$project/.htaccess
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
​
# SET WPRIG
	wget https://github.com/wprig/wprig/archive/master.zip
	unzip master.zip
	mv wprig-master ./$project/wp-content/themes/wprig
	rm -rf master.zip
	# get js dependencies with gulpfile (I think composer needs to be global on machine)
	
# FIX PROJECT PREFERENCES (with user that is part of group www-data or _www (on mac))
	sudo chown -R $owner:www-data $project
	# sudo chmod -R 777 $project

# CREATE EMPTY DATABASE, use same name in wp-config
	sudo mysql -u$mysqlusr -p$mysqlpwd -e "CREATE DATABASE $dbname"