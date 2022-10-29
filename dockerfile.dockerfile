FROM node:18-alpine

RUN mkdir -p /home/server
WORKDIR /home/server
COPY . /home/server/
RUN yarn

EXPOSE 3000
CMD npm run dev