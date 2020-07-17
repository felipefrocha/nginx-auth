FROM nginx:latest
ENV BASIC_AUTH_USERNAME admin
ENV BASIC_AUTH_PASSWORD admin
ENV PORT 4000
ENV PORT_FRONT 5000
ENV PORT_BACK 8081
ENV NAME_FRONT localhost
ENV NAME_BACK localhost
ENV DOMAIN host
ENV SUBDOMAIN local
ENV API_BASE_PATH api

STOPSIGNAL SIGQUIT

RUN apt update -y \
    && apt full-upgrade -y \
    && apt install iputils-ping apache2-utils dnsutils -y \
    && htpasswd -bBc /etc/nginx/.htpasswd ${BASIC_AUTH_USERNAME} ${BASIC_AUTH_PASSWORD} 

COPY entrypoint.sh /
COPY nginx.conf.tmpl /nginx.conf.tmpl
RUN chmod +x entrypoint.sh
CMD ["bash", "-c", "/entrypoint.sh"]