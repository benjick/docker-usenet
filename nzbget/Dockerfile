FROM gliderlabs/alpine:3.3
RUN echo "@testing http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
RUN apk add --no-cache nzbget@testing

EXPOSE 6789

VOLUME /volumes/config
VOLUME /volumes/media

COPY docker-entrypoint.sh /entrypoint.sh

RUN mkdir -p /usr/local/etc
ENTRYPOINT ["/entrypoint.sh"]
CMD ["nzbget", "-s", "-c", "/volumes/config/nzbget.conf"]

#nzbget -s -c /volumes/config/nzbget.conf
