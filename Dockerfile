FROM alpine:edge
MAINTAINER Paul Ward <pnward@googlemail.com>

RUN apk --update add python3 py3-pip lighttpd php8 php8-pear iputils cacti net-snmp-tools fcgi php8-cgi mariadb-client perl && \
    rm /var/cache/apk/*
RUN pip install supervisor supervisor-stdout
RUN ln -s /usr/share/webapps/cacti /var/www/localhost/htdocs/cacti && \
    mkdir /run/lighttpd && \
    chown -R lighttpd:lighttpd /var/www/localhost/htdocs/cacti /run/lighttpd /usr/share/webapps/cacti/log /usr/share/webapps/cacti/rra && \
    sed -i '/#   include "mod_fastcgi.conf"/s/^#//g' /etc/lighttpd/lighttpd.conf && \
    sed -i 's/memory_limit = 128M/memory_limit = 512M/g' /etc/php8/php.ini && \
    echo "fastcgi.debug=1" >> /etc/lighttpd/lighttpd.conf && \
    echo "* * * * * php /usr/share/webapps/cacti/poller.php > /dev/null 2>&1" > /etc/crontabs/lighttpd && \
    cd /var/www/localhost/htdocs/cacti/plugins && \
    wget http://dl.cactifans.com/plugins/discovery-v1.5-1.tgz -O - | tar xz

ADD supervisord.conf /etc/supervisord.conf
ADD init.sh /
