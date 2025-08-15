#!/bin/bash
set -e

TAG_IMAGE=ghcr.io/tkw1536/texlive-docker
TAG_PATTERN='ghcr.io/tkw1536/texlive-docker:none*'
TAG_PREFIX=${TAG_IMAGE}:none-
TAG_SUFFIX=

function main() {
    SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
    cd "${SCRIPT_DIR}/../none"

    clear_images
    build_images
    tag_images
    push_images
}

function image_name() {
    name=$1

    # if the tag ends in a '-', remove it!
    desttag="${TAG_PREFIX}${name}${TAG_SUFFIX}"
    if [ "${desttag: -1}" == "-" ]; then
        desttag="${desttag%?}"
    fi;

    # echo it out
    echo $desttag
}

# untag all previous images
function clear_images() {
    echo "$ docker image ls --filter reference=\"$TAG_PATTERN\"  --format='{{.Repository}}:{{.Tag}}' | xargs -r docker rmi"
    docker image ls --filter reference="$TAG_PATTERN"  --format='{{.Repository}}:{{.Tag}}' | xargs -r docker rmi
}

function push_images() {
    echo "$ docker image ls --filter reference=\"$TAG_PATTERN\"  --format='{{.Repository}}:{{.Tag}}' | xargs -n 1 docker push"
    docker image ls --filter reference=\"$TAG_PATTERN\"  --format='{{.Repository}}:{{.Tag}}' | xargs -n 1 docker push
}

# build all image versions
function build_images() {
    docker pull debian:trixie
    while IFS= read -r version; do
       build_image "$version"
    done << EOF
5.10.1
5.12.5
5.14.4
5.16.3
5.18.4
5.20.3
5.22.4
5.24.4
5.26.3
5.28.3
5.30.3
5.32.1
5.34.3
5.36.3
5.38.4
5.40.2
5.42.0
EOF
}

# build a specific image version
function build_image() {
    version=$1
    image=$(image_name $version)
    echo "$ docker build --build-arg PERL_VERSION=perl-${version} -t  $image ."
    docker build --build-arg PERL_VERSION=perl-${version} -t  $image .
}

function tag_images() {
    while IFS= read -r aliasstring; do
        IFS=' ' read -r -a aliases <<< "$aliasstring"
        source="${aliases[0]}"
        for dest in "${aliases[@]:1}"
        do
            tag_image "$source" "$dest"
        done
    done << EOF
5.10.1      5.10
5.12.5      5.12
5.14.4      5.14
5.16.3      5.16
5.18.4      5.18
5.20.3      5.20
5.22.4      5.22
5.24.4      5.24
5.26.3      5.26
5.28.3      5.28
5.30.3      5.30
5.32.1      5.32
5.34.3      5.34
5.36.3      5.36
5.38.4      5.38
5.40.2      5.40
5.42.0      5.42      5
EOF
    tag_image "5" ""
}

# tag a specific image version
function tag_image() {
    source=$1
    dest=$2

    source_image=$(image_name $source)
    dest_image=$(image_name $dest)

    echo "$ docker tag ${source_image} ${dest_image}"
    docker tag ${source_image} ${dest_image}
}

# call the entry point
main