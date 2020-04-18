#!/bin/bash

# This is the temp fix bug with appstream.
# See https://gitlab.manjaro.org/applications/pamac/issues/772

yay appstream
zcat /usr/share/app-info/xmls/community.xml.gz | sed 's|<em>||g;s|<\/em>||g;' | gzip > "new.xml.gz"
sudo cp ./new.xml.gz /usr/share/app-info/xmls/community.xml.gz
sudo appstreamcli refresh-cache --force