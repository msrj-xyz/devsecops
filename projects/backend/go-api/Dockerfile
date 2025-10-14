FROM golang:1.20-alpine AS builder
WORKDIR /src
RUN apk add --no-cache git ca-certificates
COPY go.mod .
COPY . .
RUN go build -o /go-api ./...

FROM alpine:3.18
RUN apk add --no-cache ca-certificates
COPY --from=builder /go-api /usr/local/bin/go-api
EXPOSE 8080
USER 65532:65532
HEALTHCHECK --interval=30s --timeout=3s CMD ["/bin/sh","-c","/usr/local/bin/go-api >/dev/null 2>&1 || exit 1"]
ENTRYPOINT ["/usr/local/bin/go-api"]
