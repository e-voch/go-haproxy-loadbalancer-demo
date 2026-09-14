FROM alpine:3.20

RUN apk add --no-cache curl util-linux

COPY console.sh /console.sh
RUN chmod +x /console.sh

ENTRYPOINT ["/console.sh"]
