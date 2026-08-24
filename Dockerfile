FROM python:slim as builder

WORKDIR /build
RUN pip install "pysocha[search-pagefind] @ https://github.com/catalystcommunity/pysocha/archive/fab6f606a5a160964ebe16389637a80de62b4b1d.tar.gz"
COPY . .

RUN python -m pysocha build -c tnl_config.yaml

# Someday I'd like a single-binary version
FROM caddy:2.9.1-alpine

WORKDIR /site 
RUN mkdir /site/logs

COPY Caddyfile /etc/caddy/Caddyfile 
COPY --from=builder ./build/generated ./root
