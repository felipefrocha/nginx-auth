#!/bin/bash
set -e

echo $API_BASE_PATH
if [ -z $BASIC_AUTH_USERNAME ]; then
  echo >&2 "BASIC_AUTH_USERNAME must be set"
  exit 1
fi

if [ -z $BASIC_AUTH_PASSWORD ]; then
  echo >&2 "BASIC_AUTH_PASSWORD must be set"
  exit 1
fi


if [ -z $API_BASE_PATH ]; then
  echo >&2 "API_BASE_PATH must be set"
  exit 1
fi

echo "######## SETTING UP SERVER ########"

htpasswd -bBc /etc/nginx/.htpasswd $BASIC_AUTH_USERNAME $BASIC_AUTH_PASSWORD

sed \
    -e "s/##NAME_FRONT##/$NAME_FRONT/g" \
    -e "s/##NAME_BACK##/$NAME_BACK/g" \
    -e "s/##PORT_FRONT##/$PORT_FRONT/g" \
    -e "s/##PORT_BACK##/$PORT_BACK/g" \
    -e "s/##PORT##/$PORT/g" \
    -e "s/##SUBDOMAIN##/$SUBDOMAIN/g" \
    -e "s/##DOMAIN##/$DOMAIN/g" \
    -e "s|##API_BASE_PATH##|$API_BASE_PATH|g" \
  nginx.conf.tmpl > /etc/nginx/nginx.conf

echo "######## SERVER HAS BEEN SET ########"

rm -rf nginx.conf.tmpl*

echo "######## SERVER IS BEING INITIALIZED ########"

exec nginx -g "daemon off;"