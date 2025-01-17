FROM python:slim as builder

WORKDIR /build
RUN pip install pysocha
COPY . .

RUN python -m pysocha build -c tnl_config.yaml


FROM caddy:2.9.1-alpine

WORKDIR /site 
RUN mkdir /site/logs

COPY Caddyfile /etc/caddy/Caddyfile 
COPY --from=builder ./build/generated ./root