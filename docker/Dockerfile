FROM golang:1.16 as builder

WORKDIR /usr/local/go/src/seeker-injector

COPY src/ ./
RUN go mod download && \
  go mod vendor && \
  CGO_ENABLED=0 GOOS=linux go build -mod=vendor -o /seeker-injector *.go

FROM scratch
WORKDIR /app
COPY --from=builder /seeker-injector .
EXPOSE 8443
ENTRYPOINT ["./seeker-injector"]