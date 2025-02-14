#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.12"
# dependencies = [
#     "pysocha",
# ]
# ///


import pysocha

with open("tnl_config.yaml", "r") as config:
    pysocha.build(config)

# python -m pysocha build -c tnl_config.yaml
