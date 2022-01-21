# Choose plugin package
	# https://www.putorius.net/create-multiple-choice-menu-bash.html
	PS3='Which plugins do you need: '
	pluginBundles=("Development" "Speed&SEO" "Security" "Administrative")
	select fav in "${pluginBundles[@]}"; do
	    case $fav in
	        "Development")
	            echo "You chose $fav plugin pack!"
		    	# Run installer now
		    	wp plugin install wp-migrate-db query-monitor show-current-template code-snippets better-search-replace wp-reset --activate
	            ;;
	        "Speed&SEO")
	            echo "You chose $fav plugin pack!"
		    	# Run installer now
		    	wp plugin install litespeed-cache swift-performance-lite autoptimize slim-seo seo-by-rank-math
	            ;;
	        "Security")
	            echo "You chose $fav plugin pack!"
		    	# Run installer now
		    	wp plugin install loginizer wp-cerber
		    break
	            ;;
	        "Administrative")
	            echo "You chose $fav plugin pack!"
		    	# Run installer now
		    	wp plugin install advanced-custom-fields polylang loco-translate disable-gutenberg redirection duplicate-page disable-gutenberg disable-gutenberg-blocks contact-form-x dashboard-widgets-suite customizer-search user-switching wayfinder
		    break
	            ;;
		"Quit")
		    echo "User requested exit"
		    exit
		    ;;
	        *) echo "invalid option $REPLY";;
	    esac
	done
