FROM nginx:alpine

ENV HTPASSWD='foo:$apr1$odHl5EJN$KbxMfo86Qdve2FH4owePn.'

WORKDIR /opt

RUN apk add --no-cache gettext

COPY auth.conf auth.htpasswd launch.sh ./

RUN mkdir /app && mkdir /app/static

# make sure root login is disabled
RUN sed -i -e 's/^root::/root:!:/' /etc/shadow

## add permissions such that openshift can run nginx as a random non-root user
RUN chown -R 1001:0 /app && chmod -R ug+rwX /app && \
        chown -R 1001:0 /opt && chmod -R ug+rwX /opt && \
        chown -R 1001:0 /var/cache/nginx && chmod -R ug+rwX /var/cache/nginx && \
        chown -R 1001:0 /var/log/nginx && chmod -R ug+rwX /var/log/nginx && \
        chown -R 1001:0 /etc/nginx && chmod -R ug+rwX /etc/nginx
RUN touch /var/run/nginx.pid && \
        chown -R 1001:0 /var/run/nginx.pid && chmod -R ug+rwX /var/run/nginx.pid

USER 1001

CMD ["./launch.sh"]
