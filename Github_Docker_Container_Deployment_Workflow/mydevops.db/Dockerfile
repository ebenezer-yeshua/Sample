FROM mariadb:latest
RUN apt-get update
RUN apt-get install -y net-tools
LABEL version="1.0"
LABEL description="MariaDB Server"
HEALTHCHECK --start-period=5m \
  CMD mariadb -e 'SELECT @@datadir;' || exit 1
CMD ["mariadbd"]
USER root
