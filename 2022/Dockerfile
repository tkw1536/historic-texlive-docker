ARG HISTORIC_MIRROR=ftp://tug.org/historic/
ARG PERL_VERSION=5.36.3
FROM ghcr.io/tkw1536/texlive-docker:none-${PERL_VERSION} AS base

FROM base AS setup

# install setup dependencies
RUN apt-get update \
    && apt-get -y --no-install-recommends install \
        ca-certificates \
        libarchive-tools \
        perl \
        wget

# Download the installer, and put all the files into /installer/
ARG HISTORIC_MIRROR
RUN wget ${HISTORIC_MIRROR}/systems/texlive/2022/texlive2022.iso \
    && mkdir /installer/ \
    && bsdtar xvpC /installer/ -f texlive2022.iso \
    && rm texlive2022.iso

# install texlive in the installer directory
ADD texlive-2022.profile /installer/texlive-2022.profile
RUN cd /installer/ \
    && perl ./install-tl -profile texlive-2022.profile

# copy image for the final tag
FROM base AS final
COPY --from=setup /usr/local/texlive/2022/ /usr/local/texlive/2022/

# setup environment variables
ENV MANPATH="/usr/local/texlive/2022/texmf/doc/man:$MANPATH"
ENV INFOPATH="/usr/local/texlive/2022/texmf/doc/info:$MANPATH"
ENV PATH="/usr/local/texlive/2022/bin/x86_64-linux:$PATH"