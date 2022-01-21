#!/bin/bash
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