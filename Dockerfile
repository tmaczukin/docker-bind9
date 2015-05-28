FROM tmaczukin/debian
MAINTAINER Tomasz Maczukin "tomasz@maczukin.pl"

RUN apt-get update && apt-get upgrade -y # update_20140910111213
RUN apt-get install -y bind9 locales tzdata supervisor && apt-get clean

ENV TZ Europe/Warsaw
RUN echo "Europe/Warsaw" > /etc/timezone
RUN sed -i 's/# pl_PL.UTF-8/pl_PL.UTF-8/' /etc/locale.gen
RUN export LANG=pl_PL.UTF-8
RUN dpkg-reconfigure locales
RUN dpkg-reconfigure tzdata

ADD assets/supervisor.bind.conf /etc/supervisor/conf.d/bind.conf
ADD assets/init /usr/local/sbin/init
RUN chown root:root /usr/local/sbin/init && chmod 700 /usr/local/sbin/init

ADD assets/bind-configuration /etc/bind
ADD assets/setup /setup
RUN /setup

EXPOSE 53/udp
EXPOSE 53/tcp
VOLUME ["/etc/bind/local.conf.d"]
VOLUME ["/var/log/bind"]

ENTRYPOINT ["/usr/local/sbin/init"]
CMD ["start"]
