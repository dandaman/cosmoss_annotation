#!/bin/bash
d=$(date)
/home/lang/www.cosmoss/annotation/goa/cosmoss-annotation/make_distrib.sh
git commit -a -m "Nightly Build: $d" > /home/lang/www.cosmoss/annotation/goa/cosmoss-annotation/update.log 2>&1
git push origin master >> /home/lang/www.cosmoss/annotation/goa/cosmoss-annotation/update.log 2>&1
