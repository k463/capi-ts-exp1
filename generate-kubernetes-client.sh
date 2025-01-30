#!/usr/bin/env bash

set -euo pipefail

function main() {
  rm -rf .temp
  node ./download-crds.js
  ./generate-openapi-spec.sh
  mkdir kubernetes-client/src/gen
  # see
  # - https://github.com/kubernetes-client/gen/blob/b461333bb57fa2dc2152f939ed70bac3cef2c1f6/openapi/openapi-generator/generate_client_in_container.sh#L82
  # - https://github.com/kubernetes-client/gen/blob/b461333bb57fa2dc2152f939ed70bac3cef2c1f6/openapi/preprocess_spec.py#L565
  yq e --output-format=json .temp/openapi/openapi.yaml > kubernetes-client/src/gen/swagger.json.unprocessed
  ./kubernetes-client/generate-client.sh
}

main
