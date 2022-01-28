These directories contain base Dockerfiles that you can use to build the container image for the sidecars

You should build these and store them in your own Docker registry. There are some arguments that will need to be set

| Argument                  | Description                                                                   |
|---------------------------|-------------------------------------------------------------------------------|
| SEEKER_DOWNLOAD_URL       | The URL for downloading the seeker agent for your chosen technology           |
| SEEKER_DOWNLOAD_LOCATION  | Location to download  the agent to (defaults set in Dockerfile)               |
| SEEKER_DATA_DIR           | For nodeJS only, sets the data dir for seeker package (default in Dockerfile) |

# Usage

The node and dotnetcore images should be built and stored in your image registry. Reference these in your sidecare config by using the values. 

```yaml
sidecar:
  registry: "https://my.reg.url"
  repo: "seeker-injector"
  version: "1.0.0"
  imagePullPolicy: IfNotPresent
```

**NOTE: You should store the image as {name-tech} as the injector will take repo as a base name and append the value of seeker.injector/tech to the end** e.g. seeker-injector-nodejs:1.0.0 This reduces the amount of config that has to be mantained and allows for quickly expanding the technologies that are supported. Be sure to add `imagePullSecrets` to your manifest if you're using a private registry.

The Go base image should be used as part of your Docker image build process as below. This is because the Go agent should be built into your app rather than be used to run the app.

```Dockerfile
FROM seeker-golang-base:1.0.0 as builder

WORKDIR /

ARG SEEKER_ACCESS_TOKEN
ARG SEEKER_SERVER_URL
ARG SEEKER_PROJECT_KEY  
ARG SEEKER_AGENT_NAME

COPY src/*.go ./
RUN go mod download && \
  go mod vendor && \
  CGO_ENABLED=0 GOOS=linux myapp go build -mod=vendor -o /myapp

FROM scratch
WORKDIR /app
COPY --from=builder /myapp .
EXPOSE 8443
ENTRYPOINT ["./myapp"]
```
