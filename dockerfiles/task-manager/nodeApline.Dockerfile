# Use latest version of node
FROM node:20-alpine3.17

# Plop in code
RUN mkdir -p /app/taskManager/
COPY . /app/taskManager/

# Set working directory for app
WORKDIR /app/taskManager/
CMD node index.js