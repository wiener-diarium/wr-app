#bin/bash

# remove public/editions
rm -r ./edition/raw
# create public/editions
mkdir ./edition/raw
# Copy data to public folder
cp -r ./data/editions/legacy/*.xml ./edition/raw/
cp -r ./data/editions/present/*.xml ./edition/raw/
