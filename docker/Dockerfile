FROM golang:1.16 as builder

WORKDIR /usr/local/go/src/seeker-injector

COPY src/*.go ./
RUN go mod download && \
  go mod vendor && \
  go build -mod=vendor -o /seeker-injector

FROM scratch
WORKDIR /app
COPY --from=builder /seeker-injector .
EXPOSE 8443
ENTRYPOINT ["./seeker-injector"]