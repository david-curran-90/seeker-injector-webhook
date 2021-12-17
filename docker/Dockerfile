FROM drfostercontainerreg.azurecr.io/kpe-seeker-base-golang:0.2.5 as builder

WORKDIR /usr/local/go/src/seeker-injector

ARG SEEKER_ACCESS_TOKEN
ARG SEEKER_SERVER_URL
ARG SEEKER_PROJECT_KEY  
ARG SEEKER_AGENT_NAME

COPY src/*.go ./
RUN go mod download && \
  go mod vendor && \
  CGO_ENABLED=0 GOOS=linux seeker-agent go build -mod=vendor -o /seeker-injector

FROM scratch
WORKDIR /app
COPY --from=builder /seeker-injector .
EXPOSE 8443
ENTRYPOINT ["./seeker-injector"]