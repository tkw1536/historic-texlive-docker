#!/bin/bash

YEAR=$1
if [ -z "$YEAR" ]; then
    echo "Need Year" >&2
    exit 1
fi;
TAGNAME="historic-texlive-profile"

docker build --no-cache --build-arg HISTORIC_MIRROR=https://pi.kwarc.info/historic/ --build-arg HISTORIC_YEAR=${YEAR} -t "$TAGNAME" - 1>&2 <<"END"
FROM debian:buster as base

FROM base as setup

# install setup dependencies
RUN apt-get update \
    && apt-get -y --no-install-recommends install \
        ca-certificates \
        bsdtar \
        perl \
        wget

# Download the installer, and put all the files into /installer/
ARG HISTORIC_MIRROR
ARG HISTORIC_YEAR
RUN wget ${HISTORIC_MIRROR}/systems/texlive/${HISTORIC_YEAR}/texlive${HISTORIC_YEAR}.iso \
    && mkdir /installer/ \
    && bsdtar xvpC /installer/ -f texlive${HISTORIC_YEAR}.iso \
    && rm texlive${HISTORIC_YEAR}.iso

# run the "interactive" installer by passing install to it, to install inside the docker
RUN cd /installer/; echo i | perl ./install-tl -repository /installer/
END

docker run -ti --rm "$TAGNAME" cat /usr/local/texlive/${YEAR}/tlpkg/texlive.profile
docker image rm "$TAGNAME" 1>&2
