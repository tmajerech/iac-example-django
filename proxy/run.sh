#!/bin/sh
set -e

echo "== Templated NGINX config =="
envsubst '${LISTEN_PORT} ${APP_HOST} ${APP_PORT}' \
  < /etc/nginx/default.conf.tpl \

echo "== Writing config and starting NGINX =="
envsubst '${LISTEN_PORT} ${APP_HOST} ${APP_PORT}' \
  < /etc/nginx/default.conf.tpl \
  > /etc/nginx/conf.d/default.conf

nginx -g 'daemon off;'