# #build
# FROM node:16-alpine as build
# # Create app directory
# WORKDIR /usr/src/app
# COPY . .
# RUN npm install \    
#      && npm run build

# #release
# FROM nginxproxy/nginx-proxy
# WORKDIR /app
# COPY --from=build /usr/src/app/dist/frontend /usr/share/nginx/html
# COPY ./nginx.tmpl /app
# EXPOSE 80

FROM nginx:stable-alpine
WORKDIR /app
COPY ./public_html /usr/share/nginx/html
EXPOSE 80