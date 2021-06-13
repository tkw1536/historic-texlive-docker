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
RUN wget ${HISTORIC_MIRROR}/systems/texlive/2014/texlive2014.iso \
    && mkdir /installer/ \
    && bsdtar xvpC /installer/ -f texlive2014.iso \
    && rm texlive2014.iso

RUN cd /installer/; echo i | perl ./install-tl -repository /installer/; cat /usr/local/texlive/*/tlpkg/texlive.profile

# install texlive in the installer directory
ADD texlive-2014.profile /installer/texlive-2014.profile
RUN cd /installer/ \
    && perl ./install-tl -profile texlive-2014.profile

# copy image for the final tag
FROM base as final
COPY --from=setup /usr/local/texlive/2014/ /usr/local/texlive/2014/

# setup environment variables
ENV MANPATH="/usr/local/texlive/2014/texmf/doc/man:$MANPATH"
ENV INFOPATH="/usr/local/texlive/2014/texmf/doc/info:$MANPATH"
ENV PATH="/usr/local/texlive/2014/bin/x86_64-linux:$PATH"