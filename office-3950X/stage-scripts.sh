#!/bin/bash

# Stages the scripts for usage

mv ./01-partition-disk.sh ./01-partition-disk.sh.orig && chmod -x ./01-partition-disk.sh.orig
cp ./office-3950X/01-partition-disk.sh .
mv ./06-ui-setup.sh ./06-ui-setup.sh.orig && chmod -x ./06-ui-setup.sh.orig
cp ./office-3950X/06-ui-setup.sh .