#!/usr/bin/env bash

set -euo pipefail

function generateSpec() { # inDir outFile
  mkdir -p "$(dirname "${2:?specify outFile}")"
  npx --package=crdtoapi -- crdtoapi \
    --apiVersion "$(date +%Y%m%d%H%M%S)" --in "${1:?specify inDir}" --out "$2"
  # ctdtoapi doesn't include `paths` field which is required here:
  # https://github.com/kubernetes-client/gen/blob/b461333bb57fa2dc2152f939ed70bac3cef2c1f6/openapi/preprocess_spec.py#L164
  yq e --inplace '.paths = {}' "$2"
}

function main() {
  generateSpec ./.temp/crds/ ./.temp/openapi/openapi.yaml
  #for typePth in ./.temp/crds/*; do
  #  local type_
  #  type_="${typePth#./.temp/crds/}"
  #  for namePth in "${typePth}/"*; do
  #    local name
  #    name="${namePth#${typePth}/}"
  #    echo "type_: ${type_}, name: ${name}"
  #    generateSpec "${namePth}/" "./.temp/openapi/${type_}/${name}.openapi.yaml"
  #  done
  #done
}

main
