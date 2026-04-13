#!/bin/bash

set -o pipefail

# copy test-values into charts
rsync -a chart-tests/ charts/

# run chart tests
ct install --config .github/workflows/conf/ct-test.yml | tee .tmp/ct-test.log

exit $?
