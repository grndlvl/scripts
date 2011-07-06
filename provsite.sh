#!/usr/bin/env bash
# Drupal CVS provisioning script using XAMPP

if [ "$1" == "" ]; then
echo
echo "Usage: provision_site.sh \$1){domain name} \$2){database user} \$3){database name} \$4){site status}"
echo
exit
fi

domain_name="${1}";
database_user="${2}";
database_name="${3}";
site_status="${4}";
vhost_template='/Users/jonathan/XAMPP/etc/sites-avaliable/default_template';
vhost_dir='/Users/jonathan/XAMPP/etc/sites-avaliable';
vhost_enable='/Users/jonathan/XAMPP/etc/sites-enabled';
base_logroot_dir='/Users/jonathan/Sites';
base_docroot_dir='/Users/jonathan/Sites';
site_root_dir="${base_docroot_dir}/${domain_name}";
site_logroot_dir="${base_logroot_dir}/${domain_name}/${site_status}/logs";
site_docroot_dir="${base_docroot_dir}/${domain_name}/${site_status}/htdocs";
base_url='.local';

if [[ -z "$domain_name" || -z "$site_status" ]]; then
    echo 'You must supply a sitename';
    else
        if [[ -z "$database_user" || -z "$database_name" ]]; then
            echo 'You must supply a database user and database name';
            exit 1;
        else
            echo "Attempting to create the database schema ${database_name} ...";
            if mysql -u${database_user} -e "CREATE DATABASE ${database_name}" -p
            then
                echo -n 'success!';
                echo
            else
                echo 'there was a problem creating the database... exiting';
                exit 1;
            fi
        fi
        
        echo "provisioning space...";
        if [ -d $site_docroot_dir ]; then
            echo 'site directory already exists, exiting';
            exit;
        else
            echo "creating $site_docroot_dir ..."
            if mkdir -p $site_docroot_dir
            then
                echo -n "success!"
                echo
            else
                echo "could not create $site_docroot_dir ... exiting"
                exit 1;
            fi
            
            echo "creating $site_logroot_dir ..."
            if mkdir -p $site_logroot_dir
            then
                echo -n "success!"
                echo
            else
                echo "could not create $site_logroot_dir ... exiting"
                exit 1;
            fi
        fi
        
        #rsync -rv --exclude '.svn' ${site_root_dir}/svnroot/  $site_docroot_dir/
        echo 'Creating host file';
        sudo sh -c "echo \"127.0.0.1 \t ${domain_name}${base_url}\" >> /etc/hosts"
        echo 'Creating vhost';
        cp $vhost_template ${vhost_dir}/${domain_name}_${site_status};
        sed -i '' -e "s:@@@SITENAME@@@:${domain_name}:g" ${vhost_dir}/${domain_name}_${site_status};
        sed -i '' -e "s:@@@SITESTATUS@@@:${site_status}:g" ${vhost_dir}/${domain_name}_${site_status};
        sh -c "ln -s ${vhost_dir}/${domain_name}_${site_status} ${vhost_enable}/${domain_name}_${site_status}"
        echo "Site Complete. Restart Apache and Please visit http://${domain_name}${base_url}/install.php ";
        echo 'Restarting Apache';
        sudo sh -c 'xampp restartapache' >> /dev/null
        exit 0;
fi
