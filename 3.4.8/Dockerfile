FROM java:8-jre-alpine
MAINTAINER Elisey Zanko <elisey.zanko@gmail.com>

# Install required packages
RUN apk add --no-cache \
    bash

ENV ZOOKEEPER_USER zookeeper
# If you change this then you have to change dataDir in zoo.cfg
ENV ZOOKEEPER_DATA_DIR /tmp/zookeeper

# Add a user and make dirs
RUN set -x \
    && adduser -D "$ZOOKEEPER_USER" \
    && mkdir -p "$ZOOKEEPER_DATA_DIR" \
    && chown -R "$ZOOKEEPER_USER:$ZOOKEEPER_USER" "$ZOOKEEPER_DATA_DIR"

ENV GPG_KEY 2A4A8024702DD5FC061ABCD8BE3B6B9392BC2F2B
ENV DISTRO_NAME zookeeper-3.4.8
ENV PATH $PATH:/$DISTRO_NAME/bin

# Download Apache Zookeeper, verify its PGP signature, untar and clean up
RUN set -x \
    && apk add --no-cache --virtual .build-deps \
        gnupg \
    && wget -q "http://www-eu.apache.org/dist/zookeeper/$DISTRO_NAME/$DISTRO_NAME.tar.gz" \
    && wget -q "http://www.us.apache.org/dist/zookeeper/$DISTRO_NAME/$DISTRO_NAME.tar.gz.asc" \
    && export GNUPGHOME="$(mktemp -d)" \
    && gpg --keyserver ha.pool.sks-keyservers.net --recv-key "$GPG_KEY" \
    && gpg --batch --verify "$DISTRO_NAME.tar.gz.asc" "$DISTRO_NAME.tar.gz" \
    && tar -xzf "$DISTRO_NAME.tar.gz" \
    && cp "$DISTRO_NAME/conf/zoo_sample.cfg" "$DISTRO_NAME/conf/zoo.cfg" \
    && chown -R "$ZOOKEEPER_USER:$ZOOKEEPER_USER" "$DISTRO_NAME" \
    && rm -r "$GNUPGHOME" "$DISTRO_NAME.tar.gz" "$DISTRO_NAME.tar.gz.asc" \
    && apk del .build-deps

WORKDIR $DISTRO_NAME
USER $ZOOKEEPER_USER

VOLUME ["$ZOOKEEPER_DATA_DIR"]
EXPOSE 2181

CMD ["zkServer.sh", "start-foreground"]
