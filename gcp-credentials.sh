#!/bin/bash

set -e

echo "PWD $PWD"
openssl des3 -d -in ./etc/travis/travis-gcp-deploy.json.des3 -out ./etc/travis/travis-gcp-deploy.json -pass pass:$GCP_CREDENTIALS

