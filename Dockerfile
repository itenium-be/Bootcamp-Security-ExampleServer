FROM node:16

WORKDIR /app
COPY package*.json ./
COPY server.js .
RUN npm install
EXPOSE 5000
CMD [ "node", "server.js" ]
