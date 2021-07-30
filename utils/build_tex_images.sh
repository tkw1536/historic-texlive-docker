#!/bin/bash
set -e

TAG_IMAGE=ghcr.io/tkw1536/texlive-docker
TAG_PATTERN='ghcr.io/tkw1536/texlive-docker:*'
TAG_PREFIX=${TAG_IMAGE}:
TAG_SEPERATOR=-
TAG_SUFFIX=

HISTORIC_MIRROR=https://pi.kwarc.info/historic/

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

function main() {
    # clear_images
    build_images
    tag_images
    push_images
}

# image for a perl / tex combination
function image_name() {
    tex=$1
    perl=$2

    simple_image_name "${tex}${TAG_SEPERATOR}${perl}"
}

function simple_image_name() {
    # if the tag ends in a '-', remove it!
    desttag="${TAG_PREFIX}$1${TAG_SUFFIX}"
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

# push all the images
function push_images() {
    echo "$ docker image ls --filter reference=\"$TAG_PATTERN\"  --format='{{.Repository}}:{{.Tag}}' | xargs -n 1 docker push"
    docker image ls --filter reference=$TAG_PATTERN  --format='{{.Repository}}:{{.Tag}}' | xargs -n 1 docker push
}

# build all image versions
function build_images() {
    while IFS= read -r tagstring; do
        IFS=' ' read -r -a tag <<< "$tagstring"
        tex=${tag[0]}
        perl=${tag[1]}
        build_image "$tex" "$perl"
    done << EOF
2008 5.10.1
2009 5.10.1
2010 5.12.5
2011 5.14.4
2012 5.16.3
2013 5.18.4
2014 5.20.3
2015 5.22.4
2016 5.24.4
2017 5.26.3
2018 5.28.3
2019 5.30.3
2020 5.32.1
2021 5.34.0
EOF
}
# build a specific image version
function build_image() {
    tex=$1
    perl=$2
    image=$(image_name $tex $perl)

    pushd "${SCRIPT_DIR}/../$tex"

    # build the image
    echo "$ docker build --no-cache --build-arg PERL_VERSION=${perl} --build-arg HISTORIC_MIRROR=${HISTORIC_MIRROR} -t  $image ."
    docker build --no-cache --build-arg PERL_VERSION=${perl} --build-arg HISTORIC_MIRROR=${HISTORIC_MIRROR} -t  $image .

    # remove dangling images
    docker images -q --filter "dangling=true" | xargs -r -n 1 docker rmi --force

    popd 2>&1
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
2008-5.10.1 2008-5.10 2008-5 2008
2009-5.10.1 2009-5.10 2009-5 2009
2010-5.12.5 2010-5.12 2010-5 2010
2011-5.14.4 2011-5.14 2011-5 2011
2012-5.16.3 2012-5.16 2012-5 2012
2013-5.18.4 2013-5.18 2013-5 2013
2014-5.20.3 2014-5.20 2014-5 2014
2015-5.22.4 2015-5.22 2015-5 2015
2016-5.24.4 2016-5.24 2016-5 2016
2017-5.26.3 2017-5.26 2017-5 2017
2018-5.28.3 2018-5.28 2018-5 2018
2019-5.30.3 2019-5.30 2019-5 2019
2020-5.32.1 2020-5.32 2020-5 2020
2021-5.34.0 2021-5.34 2021-5 2021 latest
EOF
}

# tag a specific image version
function tag_image() {
    sourcename=$1
    dest=$2

    source_image=$(simple_image_name $source)
    dest_image=$(simple_image_name $dest)

    echo "$ docker tag ${source_image} ${dest_image}"
    docker tag ${source_image} ${dest_image}
}

# call the entry point
main