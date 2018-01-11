FROM fedora
LABEL Description="A DNS master server"

RUN dnf install -y bind bind-utils && dnf clean all

RUN mkdir -p /exports/hostfs/etc/named/ /exports/hostfs/var/ \
    && cp /etc/named.* /exports/hostfs/etc/ \
    && cp -r /var/named/ /exports/hostfs/var/
COPY config.json.template /exports
