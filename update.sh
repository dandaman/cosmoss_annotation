#!/bin/bash
d=$(date)
git commit -a -q -uno -m "Nightly Build: $d" 
git push -q origin master 
