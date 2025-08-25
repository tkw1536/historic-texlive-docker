ARG CTAN_MIRROR=https://ftp.fau.de/ctan/
ARG PERL_VERSION=5.42.0
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
ARG CTAN_MIRROR
RUN wget ${CTAN_MIRROR}/systems/texlive/Images/texlive2025.iso \
    && mkdir /installer/ \
    && bsdtar xvpC /installer/ -f texlive2025.iso \
    && rm texlive2025.iso

# install texlive in the installer directory
ADD texlive-2025.profile /installer/texlive-2025.profile
RUN cd /installer/ \
    && perl ./install-tl -profile texlive-2025.profile

# copy image for the final tag
FROM base AS final
COPY --from=setup /usr/local/texlive/2025/ /usr/local/texlive/2025/

# setup environment variables
ENV MANPATH="/usr/local/texlive/2025/texmf/doc/man:$MANPATH"
ENV INFOPATH="/usr/local/texlive/2025/texmf/doc/info:$MANPATH"
ENV PATH="/usr/local/texlive/2025/bin/x86_64-linux:$PATH"