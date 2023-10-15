#!/bin/bash
# in this version we are switching to WP-CLI tool, and using BASH shell because plugin select procedure requires it
echo "THIS IS THE WORDPRESS INSTALLER (wp-cli based)"
# get the data in
		echo  "# WARNING: run this in your webroot!"
	# the project title
		read -p "# PROJECT TITLE: " project

	# the project owner (member of groups _www on mac or www-data on linux)
		read -p "# USER (local sudo user): " owner

	# the db password
		read -p "# PASSWORD (for wp and mysql to use): " pass

	# choose the site setup
	read -p "# CHOOSE STACK (write number):
	(1) builderius
	(2) barebones fse
	(3) generatepress & generateblocks
	(4) oxygenbuilder
	(5) bricks
	(6) wp defaults
	(7) skip to plugins
	: " theme

# CORE INSTALL STACK INSTALL BLOCK, SKIPPED IF OPTSIO 7 WAS SELECTED
if [[ $theme != "7" ]]
	then
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
	wp rewrite structure '%postname%'

	# THEME SECTION

	gp_child="/*
	Theme Name: project
	Author: thisbit
	Template: generatepress
	Author URI: https://github.com/thisbit/
	Description: Lorem Ipsum
	Version: 1.0
	Text Domain: project_
	Tags: lorem, ipsum
	License: GNU General Public License v2 or later
	License URI: http://www.gnu.org/licenses/gpl-2.0.html
	*/
	"

	fse_starter="/*
	Theme Name: project
	Author: thisbit
	Author URI: https://github.com/thisbit/
	Description: Lorem Ipsum
	Version: 1.0
	Text Domain: project_
	Tags: lorem, ipsum
	License: GNU General Public License v2 or later
	License URI: http://www.gnu.org/licenses/gpl-2.0.html
	This theme is based on Bare-bones FSE Starter developed by WP Development Courses, https://wpdevelopment.courses/, by 
	Fränk Klein
	*/
	"

	if [[ $theme = "1" ]]
		#builderius stack
		then
		# clean my wp
		wp theme delete --all --force && wp plugin delete --all && wp post delete 1 2 3
		# install themes
		wp theme install ../wordpress-pro/void.zip
		# install relevant plugins
		wp plugin install builderius ../wordpress-pro/builderius-*.zip admin-site-enhancements --activate
	elif [ $theme = "2" ]
		#fse starter theme stack
		then
		# clean my wp
		wp theme delete --all --force && wp plugin delete --all && wp post delete 1 2 3
		# get theme & customize
		wp theme install ../wordpress-pro/bare-bones-fse-starter.zip
		mv ./wp-content/themes/bare-bones-fse-starter-main ./wp-content/themes/$project
		echo "$fse_starter" > ./wp-content/themes/$project/style.css
		sed -i "s/project/$project/g" ./wp-content/themes/$project/style.css

		#activate theme
		wp theme activate $project
		wp plugin install block-visibility admin-site-enhancements --activate
	elif [ $theme = "3" ]
		#generatepress stack
		then
		# clean my wp
		wp theme delete --all --force && wp plugin delete --all && wp post delete 1 2 3
		# install the parent theme
		wp theme install generatepress 

		# install the child theme
		wp theme install https://generatepress.com/api/themes/generatepress_child.zip

		#rename the child theme, and customize the style.css
		mv ./wp-content/themes/generatepress_child ./wp-content/themes/$project
		echo "$gp_child" > ./wp-content/themes/$project/style.css
		sed -i "s/project/$project/g" ./wp-content/themes/$project/style.css

		# activate the child theme
		wp theme activate $project
		# install relevant plugins
		wp plugin install generateblocks ../wordpress-pro/generatepress/gp-premium-*.zip ../wordpress-pro/generatepress/generateblocks-pro*.zip customizer-search  block-visibility admin-site-enhancements --activate
	elif [ $theme = "4" ]
		#oxygen stack
		then
		# clean my wp
		wp theme delete --all --force && wp plugin delete --all && wp post delete 1 2 3
		wp theme install ../wordpress-pro/oxygen/thisbit-void.zip --activate
		wp plugin install ../wordpress-pro/oxygen/oxygen.*.zip ../wordpress-pro/oxygen/oxygen-gutenberg.*.zip ../wordpress-pro/oxygen/oxygen-woocommerce.*.zip ../wordpress-pro/core-framework*.zip admin-site-enhancements --activate
	elif [ $theme = "5" ]
		#BricksBuilder
		then
		# clean my wp
		wp theme delete --all --force && wp plugin delete --all && wp post delete 1 2 3
		wp theme install ../wordpress-pro/bricksbuilder*.zip --activate
		wp plugin install admin-site-enhancements --activate
	elif [ $theme = "6" ]
		then
		echo "Ok stay with the default install"
	else
		echo "ERROR, you failed to choose an available theme!"
		exit
	fi
	echo "Theme setup, done!"
	cd .. && sudo chmod 777 -R $project && sudo chown www-data:www-data -R $project

# END OF CORE STACK INSTALL
fi
	
# ADDITIONAL PLUGIN BUNDLES SECTION 
	cd $project
	# https://www.putorius.net/create-multiple-choice-menu-bash.html
	PS3='Which plugins do you need: '
	pluginBundles=("Base one" "Base two" "Multilang" "Users and Capabilities" "Development" "Browser Coder" "Backup & Migration" "Quit")
	
	bundle_options="
	1) CPTUI & ACF Pro & Slim SEO                       
	2) MetaBox & Slim SEO             
	3) Polylang & Loco Translate                  
	4) User Role Editor & User Switching
	5) Query Monitor & WP Console & Debug Log Manager
	6) WPCodeBox & Variable Inspector
	7) WP Vivid & Better Search Replace
	8) Quit
	"

	select bundle in "${pluginBundles[@]}"; do
	    case $bundle in
	        "Base one")
	            echo "You chose $bundle plugin pack!"
		    	# Run installer now
		    	wp plugin install custom-post-type-ui ../../serv/wordpress-pro/advanced-custom-fields-pro.zip slim-seo --activate
	echo "$bundle_options"
	            ;;
	        "Base two")
	            echo "You chose $bundle plugin pack!"
		    	# Run installer now
		    	wp plugin install ../../serv/wordpress-pro/metabox/meta-box-aio.zip slim-seo --activate
	echo "$bundle_options"
	            ;;
	        "Multilang")
	            echo "You chose $bundle plugin pack!"
		    	# Run installer now
		    	wp plugin install polylang loco-translate --activate
	echo "$bundle_options"
	            ;;
	        "Users and Capabilities")
	            echo "You chose $bundle plugin pack!"
		    	# Run installer now
		    	wp plugin install user-role-editor user-switching --activate
	echo "$bundle_options"
	            ;;
    	     "Development")
   	            echo "You chose $bundle plugin pack!"
   		    	# Run installer now
   		    	wp plugin install query-monitor wp-console debug-log-manager --activate
	echo "$bundle_options"
   	            ;;
   	 	    "Browser Coder")
 	           	echo "You chose $bundle plugin pack!"
 	      		# Run installer now
 	           	wp plugin install ../../wordpress-pro/wpcodebox2.zip variable-inspector --activate
	echo "$bundle_options"
   	            ;;
            "Backup & Migration")
 	           	echo "You chose $bundle plugin pack!"
 	       		# Run installer now
 	           	wp plugin install wpvivid-backuprestore better-search-replace
	echo "$bundle_options"
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
	cd ..
# END OF PLUGIN BUNDLES SECTION
exit

