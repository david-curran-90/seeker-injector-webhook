FROM golang:1.16 as builder

WORKDIR /usr/local/go/src/seeker-injector

COPY src/ ./
RUN go mod download && \
  go mod vendor && \
  CGO_ENABLED=0 GOOS=linux go build -mod=vendor -o / *.go

FROM scratch
WORKDIR /app
COPY --from=builder /write-backend .
CMD ["./write-backend"]