#!/bin/bash
# in this version we are switching to WP-CLI tool, and using BASH shell because plugin select procedure requires it

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
		(6) none (wp defaults)
		: " theme

# GETING WORDPRESS AND SETTING DATABASE SECTION

# get and clean new wordpress
mkdir $project && cd $project && wp core download

# set base wp-config
wp config create --dbname=$project --dbuser=$owner --dbpass=$pass --locale=hr --dbprefix=stroj_

# create database
wp db create


# SERVER SECTION


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



# WORDPRESS INSTALL SECTION


wp core install --url=$project.stroj --title=$project --admin_user=$owner --admin_password=$pass --admin_email=$owner@$project.stroj


# THEME SECTION

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
		# clean my wp
		wp theme delete --all --force && wp plugin delete --all && wp post delete 1 2 3
		wget https://github.com/wprig/wprig/archive/master.zip
		unzip master.zip
		mv wprig-master ./wp-content/themes/wprig-$project
		rm -rf master.zip
		wp theme activate wprig-$project
	elif [ $theme = "2" ]
		then
		# clean my wp
		wp theme delete --all --force && wp plugin delete --all && wp post delete 1 2 3
		wget https://github.com/Automattic/_s/archive/master.zip
		unzip master.zip
		mv _s-master ./wp-content/themes/_s-$project
		rm -rf master.zip
		wp theme activate _s-$project
		# see if you can automate string replacement "_s" with "$project"
	elif [ $theme = "3" ]
		then
		# clean my wp
		wp theme delete --all --force && wp plugin delete --all && wp post delete 1 2 3
		# install themes
		wp theme install generatepress https://generatepress.com/api/themes/generatepress_child.zip && wp theme activate generatepress_child
		# install relevant plugins
		wp plugin install generateblocks ../wordpress-pro/generatepress/gp-premium-*.zip ../wordpress-pro/generatepress/generateblocks-pro*.zip --activate
	elif [ $theme = "4" ]
		then
		# clean my wp
		wp theme delete --all --force && wp plugin delete --all && wp post delete 1 2 3
		wp theme install ../wordpress-pro/oxygen/thisbit-void.zip --activate
		wp plugin install ../wordpress-pro/oxygen/oxygen.*.zip ../wordpress-pro/oxygen/oxygen-gutenberg.*.zip ../wordpress-pro/oxygen/oxygen-woocommerce.*.zip ../wordpress-pro/oxygen/oxy-ninja*.zip --activate
	elif [ $theme = "5" ]
		then
		# clean my wp
		wp theme delete --all --force && wp plugin delete --all && wp post delete 1 2 3
		wp theme install ../wordpress-pro/enfold*/enfold*.zip
		mv ./wp-content/themes/enfold* ./wp-content/themes/enfold
		mkdir ./wp-content/themes/enfold-child/
		echo "$enfold_child_css_header" > ./wp-content/themes/enfold-child/style.css
		sed -i "s/project/$project/g" ./wp-content/themes/enfold-child/style.css
		wp theme activate enfold-child
	elif [ $theme = "6" ]
		then
		echo "Ok stay with the default install"
	else
		echo "ERROR, you failed to choose an available theme!"
		exit
	fi
	echo "Theme setup, done!"

# PLUGINS SECTION

	# https://www.putorius.net/create-multiple-choice-menu-bash.html
	PS3='Which plugins do you need: '
	pluginBundles=("Development" "Speed&SEO" "Security" "Administrative" "Quit")
	select bundle in "${pluginBundles[@]}"; do
	    case $bundle in
	        "Development")
	            echo "You chose $bundle plugin pack!"
		    	# Run installer now
		    	wp plugin install wp-migrate-db query-monitor show-current-template code-snippets better-search-replace wp-reset --activate
	            echo "
1) Development                          
2) Speed&SEO               
3) Security                     
4) Administrative
5) Quit
	            "
	            ;;
	        "Speed&SEO")
	            echo "You chose $bundle plugin pack!"
		    	# Run installer now
		    	wp plugin install litespeed-cache swift-performance-lite autoptimize slim-seo seo-by-rank-math
		    	echo "
1) Development                          
2) Speed&SEO               
3) Security                     
4) Administrative
5) Quit
	            "
	            ;;
	        "Security")
	            echo "You chose $bundle plugin pack!"
		    	# Run installer now
		    	wp plugin install loginizer wp-cerber
		    	echo "
1) Development                          
2) Speed&SEO               
3) Security                     
4) Administrative
5) Quit
	            "	            ;;
	        "Administrative")
	            echo "You chose $bundle plugin pack!"
		    	# Run installer now
		    	wp plugin install advanced-custom-fields polylang loco-translate disable-gutenberg redirection duplicate-page disable-gutenberg disable-gutenberg-blocks contact-form-x dashboard-widgets-suite customizer-search user-switching wayfinder
			    echo "
1) Development                          
2) Speed&SEO               
3) Security                     
4) Administrative
5) Quit
		            "
	            ;;
			"Quit")
			    echo "User requested exit"
			    exit
			    ;;
	        *) echo "invalid option $REPLY";;
	    esac
	done

# USER FEEDBACK
echo "Enjoy building with wordpress"