#!/bin/bash
#
# Retrieves and updates eml.tsv distribution
#

curl -L "https://docs.google.com/spreadsheets/d/1pi0j3xTtFaWHlUO-IjcB0kSQxA45Ew0tnk5v7-_ygH0/export?format=tsv" >> dist/eml.tsv
