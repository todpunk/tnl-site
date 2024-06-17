FROM python:slim as builder

WORKDIR /build
RUN pip install pysocha
COPY . .

RUN python -m pysocha build -c tnl_config.yaml


FROM caddy:2.8.4-alpine

WORKDIR /site 

COPY Caddyfile /etc/caddy/Caddyfile 
COPY --from=builder ./build/generated ./root

