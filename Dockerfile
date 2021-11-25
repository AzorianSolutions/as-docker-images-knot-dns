ARG DISTRO=alpine
ARG DISTRO_TAG=3.14

FROM ${DISTRO}:${DISTRO_TAG}

ARG AS_KNOT_VERSION=3.1.4

ENV KNOT_setuid=${KNOT_setuid:-KNOT} \
  KNOT_setgid=${KNOT_setgid:-KNOT} \
  KNOT_daemon=${KNOT_daemon:-no} \
  AS_KNOT_VERSION=${AS_KNOT_VERSION}

RUN apk update \
  && apk add g++ make pkgconfig autoconf gnutls-dev libtool py3-sphinx \
  lmdb-dev libedit-dev userspace-rcu-dev linux-headers libidn-dev nghttp2-libs \
  libidn2-dev openssl-dev libsodium-dev fstrm-dev h2o-dev protobuf-c-dev \
  libcap-dev

COPY src/knot-${AS_KNOT_VERSION}.tar.xz /tmp/

COPY files/* /srv/

RUN mv /srv/entrypoint.sh / \
  && tar -xf /tmp/knot-${AS_KNOT_VERSION}.tar.xz -C /tmp \
  && cd /tmp/knot-${AS_KNOT_VERSION} \
  && ./configure --prefix="" --exec-prefix=/usr --sysconfdir=/etc/knot \
  --enable-dnstap --with-module-dnstap=yes \
  --with-libnghttp2=/usr/lib/libnghttp2.so.14 \
  && make \
  && make install \
  && cd / \
  && rm -rf /tmp/knot-${AS_KNOT_VERSION} \
  && mkdir -p /var/run/knot \
  && addgroup ${KNOT_setgid} 2>/dev/null \
  && adduser -S -s /bin/false -H -h /tmp -G ${KNOT_setgid} ${KNOT_setuid} 2>/dev/null \
  && chown -R ${KNOT_setuid}:${KNOT_setgid} /var/run/knot

EXPOSE 53/tcp 53/udp

ENTRYPOINT ["sh", "/entrypoint.sh"]

CMD ["/usr/sbin/knotd", "-c", "/etc/knot/knot.conf"]
