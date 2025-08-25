#!/bin/bash
set -e

HISTORIC_YEAR=$1
if [ -z "$HISTORIC_YEAR" ]; then
    echo "Need Year" >&2
    exit 1
fi;

# temporary tag to use for generating the profile
TAGNAME="historic-texlive-profile"

# Source for the texlive iso images.
# We use our own mirrors here, as that doesn't waste anyone else's bandwidth. 

# The default "historic" image source.
HISTORIC_ISO_URL="https://pi.kwarc.info/historic/systems/texlive/${HISTORIC_YEAR}/texlive${HISTORIC_YEAR}.iso"
# The 'current' image source.
CURRENT_ISO_URL="https://ftp.fau.de/ctan/systems/texlive/Images/texlive${HISTORIC_YEAR}.iso"

# Use the historic image url by default.
# Change this to build a current profile.
ISO_URL="${HISTORIC_ISO_URL}"

docker build --no-cache --build-arg "ISO_URL=${ISO_URL}" --build-arg "HISTORIC_YEAR=${HISTORIC_YEAR}" -t "$TAGNAME" - 1>&2 <<"END"
FROM debian:trixie AS base

FROM base AS setup

# install setup dependencies
RUN apt-get update \
    && apt-get -y --no-install-recommends install \
        ca-certificates \
        libarchive-tools \
        perl \
        wget

# Download the installer, and put all the files into /installer/
ARG ISO_URL
ARG HISTORIC_YEAR
RUN wget "$ISO_URL" \
    && mkdir /installer/ \
    && bsdtar xvpC /installer/ -f texlive${HISTORIC_YEAR}.iso \
    && rm texlive${HISTORIC_YEAR}.iso

# run the "interactive" installer by passing install to it, to install inside the docker
RUN cd /installer/; echo i | perl ./install-tl -repository /installer/
END

docker run -ti --rm "$TAGNAME" cat /usr/local/texlive/${HISTORIC_YEAR}/tlpkg/texlive.profile > "texlive-${HISTORIC_YEAR}.profile"
docker image rm "$TAGNAME" 1>&2
