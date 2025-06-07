#!/bin/sh

set -e

python manage.py wait_for_db
python manage.py collectstatic --noinput
python manage.py migrate

#uwsgi --socket :9000 --workers 4 --master --enable-threads --module app.wsgi

gunicorn \
    --bind 0.0.0.0:8000 \
    --workers 2 \
    --worker-class eventlet \
    --log-level DEBUG \
    --access-logfile "-" \
    --error-logfile "-" \
    dockerapp.wsgi