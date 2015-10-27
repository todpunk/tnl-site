#!/bin/bash

PYTHONPATH=$PYTHONPATH:~/tnl-site/:~/pydozer/  python ~/pydozer/pydozer.py --conf tnl_config.py --build
cp -av generated/* /var/www/todandlorna.com/html/
