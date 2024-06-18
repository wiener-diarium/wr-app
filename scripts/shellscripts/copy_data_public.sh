#bin/bash

# remove public/editions
rm -r ./public/edition
# create public/editions
mkdir ./public/edition
# Copy data to public folder
cp -r ./edition/raw/*.xml ./public/edition/
cp -r ./edition/raw/*.xml ./public/edition/
