FROM phusion/baseimage
MAINTAINER Aggelos Avgerinos <evaggelos.avgerinos@gmail.com>

RUN apt-add-repository ppa:brightbox/ruby-ng
RUN apt-get update && apt-get dist-upgrade -qq -y
RUN apt-get install -qq -y ruby-switch ruby2.1 \
  build-essential ruby2.1-dev libpq-dev nodejs
RUN ruby-switch --set ruby2.1

RUN gem update --system --no-ri --no-rdoc
RUN gem update --no-rdoc --no-ri
RUN gem install --no-ri --no-rdoc bundler

ENV RAILS_ENV production
ENV PORT 5000
ENV SECRET_KEY_BASE skata

RUN mkdir /etc/service/jarviis
ADD config/deploy/jarviis.sh /etc/service/jarviis/run

RUN adduser --system --group jarviis
COPY . /srv/jarviis
RUN chown -R jarviis:jarviis /srv/jarviis
RUN cd /srv/jarviis && \
  /sbin/setuser jarviis bundle install --deployment \
  --without development:test
