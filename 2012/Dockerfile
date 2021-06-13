ARG HISTORIC_MIRROR=ftp://tug.org/historic/
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
RUN wget ${HISTORIC_MIRROR}/systems/texlive/2012/texlive2012.iso \
    && mkdir /installer/ \
    && bsdtar xvpC /installer/ -f texlive2012.iso \
    && rm texlive2012.iso

# install texlive in the installer directory
ADD texlive-2012.profile /installer/texlive-2012.profile
RUN cd /installer/ \
    && perl ./install-tl -profile texlive-2012.profile

# copy image for the final tag
FROM base as final
COPY --from=setup /usr/local/texlive/2012/ /usr/local/texlive/2012/

# setup environment variables
ENV MANPATH="/usr/local/texlive/2012/texmf/doc/man:$MANPATH"
ENV INFOPATH="/usr/local/texlive/2012/texmf/doc/info:$MANPATH"
ENV PATH="/usr/local/texlive/2012/bin/x86_64-linux:$PATH"