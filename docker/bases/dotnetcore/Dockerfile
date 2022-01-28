FROM mcr.microsoft.com/dotnet/aspnet:5.0
ARG SEEKER_DOWNLOAD_URL
ARG SEEKER_DOWNLOAD_LOCATION /tmp/seeker-agent.zip 

ADD ${SEEKER_DOWNLOAD_URL} ${SEEKER_DOWNLOAD_LOCATION}

RUN mkdir -p /data/seeker && \
  unzip -d /data/seeker $SEEKER_DOWNLOAD_LOCATION