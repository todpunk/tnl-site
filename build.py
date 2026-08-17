#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.12"
# dependencies = [
#     "pysocha @ https://github.com/catalystcommunity/pysocha/archive/fab6f606a5a160964ebe16389637a80de62b4b1d.tar.gz",
# ]
# ///


import pysocha

with open("tnl_config.yaml", "r") as config:
    pysocha.build(config)

# python -m pysocha build -c tnl_config.yaml
