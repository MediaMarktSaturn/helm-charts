#!/bin/bash
set -euo pipefail

pip install checkov > /dev/null 2>&1
export LOG_LEVEL=INFO
CHECK_STATUS=0

# run checkov on all chart test cases and fail only at the end
set +e

# for every chart in charts folder
for chart in $(ls -d charts/*/); do
  # trim parent folder and trailing slash from $chart
  chart=${chart/charts\/} && chart=${chart/\/}
  chart_ci=chart-tests/$chart/ci
  if [ -d "$chart_ci" ]; then
    # for every test case of this chart
    for values in $(ls $chart_ci); do
      printf "\n\n=== Checking chart $chart with test case $values ===\n\n"
      rm -rf chckv
      helm template charts/$chart --values $chart_ci/$values --name-template test-release --namespace test-ns --output-dir chckv
      checkov --config-file .github/workflows/conf/checkov.yml -d chckv
      if [ $? -ne 0 ]; then
        printf "=== Chart $chart with test case $values FAILED ===\n\n"
        CHECK_STATUS=1
      else
        printf "=== Chart $chart with test test $values SUCCEEDED ===\n\n"
      fi
    done
  fi
done

exit $CHECK_STATUS
