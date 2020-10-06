# vim:set ft=dockerfile:

# AUTHOR:         Chris Yuan <honglong@gmail.com>
# DESCRIPTION:    sslscan2 supports legacy protocols (SSLv2/v3), as well as supporting TLSv1.3
# TO_BUILD:       docker build --rm -t shyuan/docker-sslscan .
# TO_RUN:	  docker run shyuan/docker-sslscan www.wikipedia.org:443

FROM alpine:3.12 AS builder
MAINTAINER Chris Yuan "honglong@gmail.com" 

RUN \
	apk add --no-cache --virtual build-dependencies git make perl gcc libc-dev zlib-dev linux-headers && \
	git clone -b 2.0.2 --depth 1 https://github.com/rbsec/sslscan.git && \
	cd sslscan && \
	make clean && \
	make static && \
	make install && \
	cd / && \
	rm -rf /sslscan && \
	apk del --no-cache build-dependencies

FROM alpine:3.12

COPY --from=builder /usr/bin/sslscan /usr/bin/sslscan
USER nobody


ENTRYPOINT ["/usr/bin/sslscan"]
