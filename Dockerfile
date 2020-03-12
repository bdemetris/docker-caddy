FROM ubuntu:latest AS builder
COPY static/install_latest_golang.py /opt/install_latest_golang.py
RUN apt-get update && apt-get install python3 python3-pip -y
RUN pip3 install lxml requests
WORKDIR /opt
RUN python3 install_latest_golang.py
ENV GOPATH=/usr/local/go
ENV PATH=/usr/local/go/bin:${PATH}
ENV GO111MODULE=on
RUN mkdir -p /usr/local/go/plugins
COPY static/main.go /usr/local/go/plugins/main.go
RUN mkdir -p /usr/local/go/src/caddy
COPY static/main.go /usr/local/go/src/caddy/main.go
WORKDIR /usr/local/go/src/caddy
RUN go get github.com/caddyserver/caddy@11ae1aa6b88e45b077dd97cb816fe06cd91cca67
RUN go mod init
RUN env GOOS=linux GOARCH=amd64 go build -o caddy


FROM alpine:latest AS runner
RUN mkdir -p /opt/site
COPY build/caddy /opt/site/caddy
COPY static/index.html /opt/site/index.html
COPY static/Caddyfile /opt/site/Caddyfile
RUN apk add --no-cache --no-progress tini
RUN apk add libc6-compat
EXPOSE 8080/tcp
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/opt/site/caddy", "-agree", "--conf", "/opt/site/Caddyfile"]
