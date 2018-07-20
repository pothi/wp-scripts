#!/bin/bash

# for occasional testing
set -x

# version: v1.0
# for changelog, see changelog/changelog-checksum-wp.yml

mailto='user@example.com'

#--- no more editing unless you really want to! ---#

LOG_DIR=$HOME/log
LOG_FILE=$LOGDIR/checksum-wp.log
exec > >(tee -a ${LOG_FILE} )
exec 2> >(tee -a ${LOG_FILE} >&2)

if [ ! -d $LOG_DIR ] && [ ! $(mkdir -p $LOG_DIR) ]; then
    echo 'Could not find or create log directory. Exiting.'
    exit 1
fi

declare -r wp_cli=/usr/local/bin/wp

function show_usage {
    echo "Usage $(basename $0) -p path/to/wordpress example.com"
    exit 1
}

path=$PWD
if [ ! -f $path/wp-config.php ] && [ ! -f $(dirname $path)/wp-config.php ]; then
    while getopts ":p" opt; do
        case $opt in
            p)
                echo "-p was triggered."
                ;;
            \?)
                echo "Invalid option -$OPTARG"
                ;;
        esac
    done
fi

# check for the variable/s in three places
# 1 - hard-coded value
# 2 - optional parameter while invoking the script
# 3 - environment files

if [ "$DOMAIN" == ""  ]; then
    if [ "$1" == "" ]; then
    ¦   if [ "$WP_DOMAIN" != "" ]; then
    ¦   ¦   DOMAIN=$WP_DOMAIN
    ¦   else
            show_usage
    ¦   fi
    else
    ¦   DOMAIN=$1
    fi
fi


send_mail() {
    echo 'Check the log' | \
        mail -s 'WP checksum failure!' $mailto
}
