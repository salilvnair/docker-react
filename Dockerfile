# Building phase
FROM node:alpine as builder
WORKDIR '/app'
COPY package.json .
RUN npm install
COPY . .
RUN npm run build

# Running phase
FROM nginx
COPY ./nginx.conf /etc/nginx/conf.d/default.conf                              
RUN rm -rf /usr/share/nginx/html/*
COPY --from=builder /app/build /usr/share/nginx/html
COPY --from=builder /main.sh /usr/share/nginx/
RUN chmod +x /usr/share/nginx/main.sh
CMD ["/bin/sh", "/usr/share/nginx/main.sh"]