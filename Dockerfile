FROM alpine:edge
MAINTAINER Christoph Dwertmann <cdwertmann@gmail.com>

RUN apk --update add python py-pip lighttpd php cacti net-snmp-tools fcgi php-cgi mariadb-client && \
    rm /var/cache/apk/*
RUN pip install supervisor
RUN ln -s /usr/share/webapps/cacti /var/www/localhost/htdocs/cacti && \
    mkdir /run/lighttpd && \
    chown -R lighttpd:lighttpd /var/www/localhost/htdocs/cacti /run/lighttpd && \
    sed -i '/#   include "mod_fastcgi.conf"/s/^#//g' /etc/lighttpd/lighttpd.conf

ADD supervisord.conf /etc/supervisord.conf
ADD init.sh /

CMD /init.sh
