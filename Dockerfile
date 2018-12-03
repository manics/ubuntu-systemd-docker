FROM ubuntu:18.04

ENV container docker

RUN apt-get update && \
    apt-get install -y systemd && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Don't start any optional services except for the few we need.
RUN find /etc/systemd/system \
    /lib/systemd/system \
    -path '*.wants/*' \
    -not -name '*journald*' \
    -not -name '*systemd-tmpfiles*' \
    -not -name '*systemd-user-sessions*' \
    -exec rm \{} \;

RUN systemctl set-default multi-user.target

COPY setup /sbin/

STOPSIGNAL SIGRTMIN+3

CMD ["/sbin/init", "--log-target=journal"]
