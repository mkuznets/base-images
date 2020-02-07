FROM node:13.7-alpine
RUN npm install -g smee-client@v1.1.0
COPY init.sh /usr/local/bin/
ENTRYPOINT ["init.sh"]
