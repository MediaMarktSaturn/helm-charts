#!/bin/bash

# copy test-values into charts
rsync -a chart-tests/ charts/

# run chart tests
ct install --config .github/workflows/conf/ct-test.yml
