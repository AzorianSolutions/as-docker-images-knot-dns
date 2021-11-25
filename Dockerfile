ARG DISTRO=debian
ARG DISTRO_TAG=11.1-slim

FROM ${DISTRO}:${DISTRO_TAG}

ARG AS_KNOT_VERSION=3.1.4

ENV KNOT_setuid=${KNOT_setuid:-knot} \
  KNOT_setgid=${KNOT_setgid:-knot} \
  KNOT_daemon=${KNOT_daemon:-no} \
  AS_KNOT_VERSION=${AS_KNOT_VERSION}

RUN apt update \
  && apt -y install g++ make pkg-config autoconf gnutls-dev libtool \
  python3-sphinx liblmdb-dev libedit-dev liburcu-dev libnghttp2-dev \
  libidn2-dev libssl-dev libsodium-dev libfstrm-dev libh2o-dev libcap-dev \
  libh2o-evloop-dev

COPY src/knot-${AS_KNOT_VERSION}.tar.xz /tmp/

COPY files/* /srv/

RUN mv /srv/entrypoint.sh / \
  && tar -xf /tmp/knot-${AS_KNOT_VERSION}.tar.xz -C /tmp \
  && cd /tmp/knot-${AS_KNOT_VERSION} \
  && ./configure --prefix="" --exec-prefix=/usr --sysconfdir=/etc/knot \
  --enable-dnstap --with-module-dnstap=yes --with-libnghttp2=/usr/include/nghttp2/ \
  && make \
  && make install \
  && cd / \
  && rm -rf /tmp/knot-${AS_KNOT_VERSION} \
  && mkdir -p /var/run/knot \
  && adduser --system --disabled-login --no-create-home --home /tmp --shell /bin/false --group ${KNOT_setgid} 2>/dev/null \
  && chown -R ${KNOT_setuid}:${KNOT_setgid} /var/run/knot

EXPOSE 53/tcp 53/udp

ENTRYPOINT ["bash", "/entrypoint.sh"]

CMD ["/usr/sbin/knotd", "-c", "/etc/knot/knot.conf"]
