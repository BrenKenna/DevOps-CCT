# Use ubuntu
FROM ubuntu:latest

# Install updates & things around node
RUN apt-get update -y \
    && apt-get install -y gcc make git tar time hostname jq rpm

# Install nodejs
RUN apt-get install -y nodejs npm \
    && npm i -g express

# Plop code in
RUN mkdir -p /app/simpleServerApp/
COPY . /app/simpleServerApp/

# Set working directory
WORKDIR /app/simpleServerApp/