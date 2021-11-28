#!/usr/bin/env bash

rdesktop \
    -g 100% \
    -P \
    -r sound:local \
    -d REDOCU \
    -u alejandro.zabaleta \
    -p Temporal1 \
    -z \
    -x b \
    -M \
    192.168.1.50:3389

# rdesktop \
#     -g 100% \               ## desktop geometry (WxH[@DPI][+X[+Y]])
#     -P \                    ## use persistent bitmap caching
#     -r sound:local \        ## enable specified device redirection
#     -d REDOCU \             ## domain
#     -u alejandro.zabaleta \ ## user name
#     -p P@ssw0rd \           ## password
#     -z \                    ## enable rdp compression
#     -x b \                  ## RDP5 experience (m[odem 28.8], b[roadband], l[an] or hex nr.)
#     -M \                    ## use local mouse cursor
#     192.168.1.50:3389       ## server[:port]
