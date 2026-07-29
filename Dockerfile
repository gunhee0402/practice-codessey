FROM nginx:alpine
LABEL org.opencontainers.image.title="my-custom-web"
COPY site/ /usr/share/nginx/html/