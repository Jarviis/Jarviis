#!/bin/sh

export DATABASE_URL="postgresql://postgres@${POSTGRES_PORT_5432_TCP_ADDR}:${POSTGRES_PORT_5432_TCP_PORT}/jarviis_production?pool=5"

cd /srv/jarviis

/sbin/setuser jarviis bundle exec rake db:create
/sbin/setuser jarviis bundle exec rake db:migrate

exec /sbin/setuser jarviis bunlde exec \
  unicorn -p ${PORT} -c config/unicorn.rb \
  >> /var/log/rails.log 2>&1
