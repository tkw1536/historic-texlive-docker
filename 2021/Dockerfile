ARG CTAN_MIRROR=https://mirror.ctan.org
ARG PERL_VERSION=5.34.0
FROM ghcr.io/tkw1536/texlive-docker:none-${PERL_VERSION} as base

FROM base as setup

# install setup dependencies
RUN apt-get update \
    && apt-get -y --no-install-recommends install \
        ca-certificates \
        bsdtar \
        perl \
        wget

# Download the installer, and put all the files into /installer/
ARG CTAN_MIRROR
RUN wget ${CTAN_MIRROR}/systems/texlive/Images/texlive2021.iso \
    && mkdir /installer/ \
    && bsdtar xvpC /installer/ -f texlive2021.iso \
    && rm texlive2021.iso

# install texlive in the installer directory
ADD texlive-2021.profile /installer/texlive-2021.profile
RUN cd /installer/ \
    && perl ./install-tl -profile texlive-2021.profile

# copy image for the final tag
FROM base as final
COPY --from=setup /usr/local/texlive/2021/ /usr/local/texlive/2021/

# setup environment variables
ENV MANPATH="/usr/local/texlive/2021/texmf/doc/man:$MANPATH"
ENV INFOPATH="/usr/local/texlive/2021/texmf/doc/info:$MANPATH"
ENV PATH="/usr/local/texlive/2021/bin/x86_64-linux:$PATH"