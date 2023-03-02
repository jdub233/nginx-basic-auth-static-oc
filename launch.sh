#!/bin/sh

rm /etc/nginx/conf.d/default.conf || :
cp auth.conf /etc/nginx/conf.d/auth.conf
envsubst < auth.htpasswd > /etc/nginx/auth.htpasswd

nginx -g "daemon off;"
