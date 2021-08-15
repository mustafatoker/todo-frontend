# build stage
FROM node:lts-alpine as build-stage
WORKDIR /build-area
COPY package*.json ./
COPY . .
RUN npm install
RUN npm run build

# production stage
FROM nginx:stable-alpine as production-stage
WORKDIR /var/www/html/app
COPY nginx/default.conf /etc/nginx/conf.d/default.conf
COPY --from=build-stage /build-area/dist /var/www/html/app
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]