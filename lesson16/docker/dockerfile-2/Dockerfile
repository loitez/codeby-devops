FROM debian:11

LABEL maintainer="loitez@mail.ru"
LABEL description="Nginx on Debian with ENTRYPOINT"

RUN apt-get update && \
    apt-get install -y nginx && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /opt/www

COPY index.html /opt/www/index.html
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

ENTRYPOINT ["nginx", "-g", "daemon off;"]