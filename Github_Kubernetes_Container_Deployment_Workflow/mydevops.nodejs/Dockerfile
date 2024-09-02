FROM debian:bookworm AS build
ENV NODE_ENV="production"
ENV USER_NAME="node"
ENV GROUP_NAME="node"
ENV USER_PASS="*****"
ENV SITE_NAME="mydevops.com"
RUN apt-get update && \
    apt-get install -y nodejs npm
RUN useradd -m $USER_NAME && \
    echo "$USER_NAME:$USER_PASS" | chpasswd
RUN mkdir -p /home/node/$SITE_NAME 
COPY ./src/ /home/node/$SITE_NAME
RUN  chown -R $GROUP_NAME:$USER_NAME /home/node/$SITE_NAME && \
    cd /home/node/$SITE_NAME && \
    npm install
WORKDIR /home/node/$SITE_NAME
CMD ["npm", "start"]
ENV PORT 3000
EXPOSE 3000
