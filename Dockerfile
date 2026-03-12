FROM node:18-alpine

WORKDIR /usr/src/app

# install system dependencies for sqlite
RUN apk add --no-cache python3 make g++

# copy dependency files
COPY package*.json ./

# install dependencies
RUN npm install --omit=dev

# copy app
COPY . .

EXPOSE 3000

CMD ["npm", "start"]