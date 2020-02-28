FROM mkznts/build-go:0.2 as build
RUN go get -ldflags="-s -w" github.com/go-acme/lego/v3/cmd/lego@v3.4.0

FROM nginx:1.17.8-alpine
COPY --from=build /go/bin/lego /usr/bin/lego
ADD nginx.conf /etc/nginx/nginx.conf
ADD entrypoint.sh /entrypoint.sh
ENV \
  TZ=Europe/Moscow
RUN \
  rm /etc/nginx/conf.d/default.conf && \
  chmod +x /entrypoint.sh && \
  apk add --no-cache --update tzdata openssl libidn
CMD ["/entrypoint.sh"]
