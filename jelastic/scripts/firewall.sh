#!/bin/bash

/sbin/iptables -t nat -D PREROUTING -p tcp -m tcp --dport 80 -j REDIRECT --to-ports 8080
