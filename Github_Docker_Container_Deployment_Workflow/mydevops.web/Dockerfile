FROM debian:bookworm
RUN apt-get update 
RUN apt-get install -y net-tools
FROM php:8.2-apache 
RUN docker-php-ext-install pdo pdo_mysql mysqli
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
RUN a2enmod rewrite
RUN a2enmod headers
CMD ["/bin/sh", "/usr/sbin/apachectl", "-D", "FOREGROUND"]
USER root
