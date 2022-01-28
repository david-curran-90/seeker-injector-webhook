# Go Seeker Docker Base Image

This image differs slightly from the NodeJS and DotNet images in that it isn't used by the injector but is used for when building Go applications.

This is because it needs to be used at build time rather than run time. You should reference this image in your build Dockerfile

```
# Use the golang base image
FROM  AS builder

WORKDIR /build
# Add necessary environment variables for seeker connection
ARG SEEKER_ACCESS_TOKEN
ARG SEEKER_SERVER_URL=https://{{seeker.url}}:8096
ARG SEEKER_PROJECT_KEY={{Project-Key-In-Seeker}}  
ARG SEEKER_AGENT_NAME={{Name-of-your-app}}

# Copy your app into the image
COPY myapp .

# Run build as normal, using seeker agent
RUN seeker-agent go build -o webapp

# Copy app into a minimal container that only contains the build app
FROM scratch
WORKDIR /app
COPY --from=builder /build/webapp .

ENTRYPOINT ["./webapp"]
```

Then in your app deployment you need to set the same environment variables again

```
apiVersion: apps/v1
kind: Deployment
...
spec:
  template:
    ...
    spec:
      containers:
      - name: myapp
        env:
        - name: SEEKER_SERVER_URL
          valueFrom:
            secretKeyRef:
              name: seeker-connection
              key: url
        - name: SEEKER_ACCESS_TOKEN
          valueFrom:
            secretKeyRef:
              name: seeker-connection
              key: token
        - name: SEEKER_PROJECT_KEY
          value: {project_key}
        - name: SEEKER_AGENT_NAME
          value: {project_name}
```

The `seeker-connection` secret should be created by you containing the details for connecing to Seeker.)
