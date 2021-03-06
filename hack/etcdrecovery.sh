#!/bin/bash -e

if [[ $# -ne 2 ]]; then
    echo error: $0 resourcegroup blobname
    exit 1
fi

export RESOURCEGROUP=$1
export BLOBNAME=$2

[[ -e /var/run/secrets/kubernetes.io ]] || go generate ./...
go run cmd/fakerp/main.go &

trap 'return_id=$?; set +ex; kill $(lsof -t -i :8080); wait $(lsof -t -i :8080); exit $return_id' EXIT

go run cmd/createorupdate/createorupdate.go -restore-from-blob=$BLOBNAME
