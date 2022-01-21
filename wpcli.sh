#!/bin/sh
# new wordpress install script based on wpcli

# get the data in
		echo  "# WARNING: run this in your webroot!"
	# the project title
		read -p "# PROJECT TITLE: " project

	# the project owner (member of groups _www on mac or www-data on linux)
		read -p "# USER (local sudo user): " owner

	# the db password
		read -p "# PASSWORD (for wp and mysql to use): " pass

	# choose the site setup
		read -p "# CHOOSE THEME (write number):
		(1) wprig (starter theme with build processes, linting etc),
		(2) _s underscores (simple starter theme),
		(3) generatepress
		(4) oxygenbuilder
		(5) enfold (commercial theme with blockeditor, a parent theme)
		: " theme



# get and clean new wordpress
mkdir $project && cd $project && wp core download

# set base wp-config
wp config create --dbname=$project --dbuser=$owner --dbpass=$pass --locale=hr

# create database
wp db create

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
	# sudo systemctl restart apache2
# install wordpress
wp core install --url=$project.stroj --title=$project --admin_user=$owner --admin_password=$pass --admin_email=$owner@$project.stroj

# clean my wp
wp theme delete --all --force && wp plugin delete --all && wp post delete 1 2 3

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
		mv wprig-master ./wp-content/themes/wprig-$project
		rm -rf master.zip
	elif [ $theme = "2" ]
		then
		wget https://github.com/Automattic/_s/archive/master.zip
		unzip master.zip
		mv _s-master ./wp-content/themes/_s-$project
		rm -rf master.zip
		# see if you can automate string replacement "_s" with "$project"
	elif [ $theme = "3" ]
		then
		# install themes
		wp theme install generatepress https://generatepress.com/api/themes/generatepress_child.zip && wp theme activate generatepress_child
		# install relevant plugins
		wp plugin install generateblocks ../wordpress-pro/generatepress/gp-premium-*.zip ../wordpress-pro/generatepress/generateblocks-pro*.zip --activate
	elif [ $theme = "4" ]
		then
		wp theme install ../wordpress-pro/oxygen/thisbit-void.zip --activate
		wp plugin install ../wordpress-pro/oxygen/oxygen.*.zip ../wordpress-pro/oxygen/oxygen-gutenberg.*.zip ../wordpress-pro/oxygen/oxygen-woocommerce.*.zip ../wordpress-pro/oxygen/oxy-ninja.*.zip --activate
	elif [ $theme = "5" ]
		then
		wp theme install ../wordpress-pro/enfold*/enfold*.zip 
		mkdir ./wp-content/themes/enfold-child/
		echo "$enfold_child_css_header" > ./wp-content/themes/enfold-child/styles.css
		sed -i "s/project/$project/g" ./wp-content/themes/enfold-child/styles.css
	else
		echo "ERROR, you failed to choose an available theme!"
		exit
	fi
	echo "theme successfully installed"

	