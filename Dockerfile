FROM alpine:edge
MAINTAINER Christoph Dwertmann <cdwertmann@gmail.com>

RUN apk --update add python py-pip lighttpd php cacti net-snmp-tools fcgi php-cgi mariadb-client perl && \
    rm /var/cache/apk/*
RUN pip install supervisor supervisor-stdout
RUN ln -s /usr/share/webapps/cacti /var/www/localhost/htdocs/cacti && \
    mkdir /run/lighttpd && \
    chown -R lighttpd:lighttpd /var/www/localhost/htdocs/cacti /run/lighttpd /usr/share/webapps/cacti/log /usr/share/webapps/cacti/rra && \
    sed -i '/#   include "mod_fastcgi.conf"/s/^#//g' /etc/lighttpd/lighttpd.conf && \
    echo "fastcgi.debug=1" >> /etc/lighttpd/lighttpd.conf && \
    echo "* * * * * php /usr/share/webapps/cacti/poller.php > /dev/null 2>&1" > /etc/crontabs/lighttpd

ADD supervisord.conf /etc/supervisord.conf
ADD init.sh /

CMD /init.sh
