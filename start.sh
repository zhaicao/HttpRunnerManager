#!/bin/bash

SETTINGS_FILE="HttpRunnerManager/settings.py"
UWSGI_FILE="uwsgi.ini"
NGINX_CONF="hrm.conf"

# available param
envparam="|SERVER_HOST|SERVER_PORT|DB_NAME|DB_USER_NAME|DB_USER_PWD|DB_HOST|DB_PORT|MQ_HOST|MQ_PORT|MQ_USER|EMAIL_USER_NAME|EMAIL_USER_PWD|"

# set default value
SERVER_HOST=${SERVER_HOST:-0.0.0.0}
SERVER_PORT=${SERVER_PORT:-8000}

DB_NAME=${DB_NAME:-httprunner}
DB_USER_NAME=${DB_USER_NAME:-httprunner}
DB_USER_PWD=${DB_USER_PWD:-httprunner}
DB_HOST=${DB_HOST:-127.0.0.1}
DB_PORT=${DB_PORT:-3306}

MQ_HOST=${MQ_HOST:-127.0.0.1}
MQ_PORT=${MQ_PORT:-5672}
MQ_USER=""

if [[ -n "$MQ_USER_NAME" && -n "$MQ_USER_PWD" ]];then
   export MQ_USER=${MQ_USER_NAME}":"${MQ_USER_PWD}
fi

for key in `echo $envparam | sed "s/|/ /g"`; do
   if grep -E -q $key ${SETTINGS_FILE} ; then
      sed -r -i "s/$key/$(eval echo '$'$key)/g" ${SETTINGS_FILE};
   else
      echo $key;
   fi
done

# start celery
source celeryAll.sh start

# nginx
cp ${NGINX_CONF} /etc/nginx/conf.d/
mkdir /run/nginx
nginx

# uwsgi
uwsgi --ini ${UWSGI_FILE}