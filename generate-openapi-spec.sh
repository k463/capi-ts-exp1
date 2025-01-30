#!/usr/bin/env bash

set -euo pipefail

function generateSpec() { # inDir outFile
  mkdir -p "$(dirname "${2:?specify outFile}")"
  npx --package=crdtoapi -- crdtoapi --in "${1:?specify inDir}" --out "$2"
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
