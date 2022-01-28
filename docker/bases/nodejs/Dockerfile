FROM node:lts-alpine3.14
ARG SEEKER_DOWNLOAD_URL
ARG SEEKER_DOWNLOAD_LOCATION /tmp/seeker-agent.zip
ARG SEEKER_DATA_DIR /data/seeker

ADD ${SEEKER_DOWNLOAD_URL} ${SEEKER_DOWNLOAD_LOCATION}

# Extract and run npm install
RUN mkdir -p $SEEKER_DATA_DIR && \
  unzip -d $SEEKER_DATA_DIR $SEEKER_DOWNLOAD_LOCATION && \
  npm install $SEEKER_DATA_DIR/seeker-agent.tgz --prefix seeker --save && \
  cp -r ./seeker/node_modules/@synopsys-sig/seeker /data