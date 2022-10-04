#!/bin/bash

D=$(basename "${PWD}")

name=${1:-$D}
mkdir -p bin

read -r h m s <<< "$(date "+%H %M %S")"
minor=$(( (h + 1) * (m + 1) * (${s#0} + 1) ))
major=$(date +%Y%m%d)
version="${major}.${minor}"

oses=( linux darwin )
archs=( amd64 arm64 )

for GOOS in "${oses[@]}";do
    for GOARCH in "${archs[@]}"; do
        echo "Building ${GOARCH} for ${GOOS}..."
        GOOS=${GOOS} GOARCH=${GOARCH} CGO_ENABLED=0 \
            go build -ldflags "-s -w -X 'main.Version=v${version}'" \
                -o "bin/${name}-${GOOS}-${GOARCH}" .
    done
done