FROM golang@sha256:679fe3791d2710d53efe26b05ba1c7083178d6375318b0c669b6bcd98f25c448 AS builder

ARG TAG=v0.2.0
ARG URI=github.com/dnstap/golang-dnstap/dnstap@$TAG

RUN apk update && apk add --no-cache git ca-certificates tzdata && update-ca-certificates
RUN adduser -D -g '' appuser

ENV GO111MODULE=on
ENV CGO_ENABLED=0
ENV GOARCH=amd64

RUN go get github.com/dnstap/golang-dnstap/dnstap@v0.2.0
RUN go build -ldflags '-w' -o /app github.com/dnstap/golang-dnstap/dnstap

FROM scratch

COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /usr/share/zoneinfo /usr/share/zoneinfo
COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /app /app

USER appuser

ENTRYPOINT ["/app"]
