#!/bin/bash
d=$(date)
git commit -a -q -uno -m "Nightly Build: $d" >> /dev/null
git push -q origin master >> /dev/null
