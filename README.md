# texlive-docker

This repository contains docker images that contain a specific TexLive and Perl versions.
The image was originally intended to be used only with [LaTeXML](https://github.com/brucemiller/LaTeXML) tests, but are general purpose. 

Supported TexLive Versions:

- TeXLive 2008, Perl 5.10
- TeXLive 2009, Perl 5.10
- TeXLive 2010, Perl 5.12
- TeXLive 2011, Perl 5.14
- TeXLive 2012, Perl 5.16
- TeXLive 2013, Perl 5.18
- TeXLive 2014, Perl 5.20
- TeXLive 2015, Perl 5.22
- TeXLive 2016, Perl 5.24
- TeXLive 2017, Perl 5.26
- TeXLive 2018, Perl 5.28
- TeXLive 2019, Perl 5.30
- TeXLive 2020, Perl 5.32
- No TeXLive, Perl 5.10 - 5.34 (see below)

## Images

The Images are available at [ghcr.io/tkw1536/texlive-docker](ghcr.io/tkw1536/texlive-docker). 
The supported tags are `${texlive}-${perl}`, for instance: `ghcr.io/tkw1536/texlive-docker:2020-5.34` will give you TeXLive 2020 with perl 5.34

Versions With TeXLive available:

(tbd)

Perl Only Tags (work in progress):

 - `none-5.34.0`, `none-5.34`, `none-5`, `none`
 - `none-5.32.1`, `none-5.32`
 - `none-5.30.3`, `none-5.30`
 - `none-5.28.3`, `none-5.28`
 - `none-5.26.3`, `none-5.26`
 - `none-5.24.4`, `none-5.24`
 - `none-5.22.4`, `none-5.22`
 - `none-5.20.3`, `none-5.20`
 - `none-5.18.4`, `none-5.18`
 - `none-5.16.3`, `none-5.16`
 - `none-5.14.4`, `none-5.14`
 - `none-5.12.5`, `none-5.12`
 - `none-5.10.1`, `none-5.10`

## Building

To build a docker image, simply `cd` into the directory of the corresponding year and use:

```
docker build --build-arg PERL_VERSION=perl-5.10.1 --build-arg HISTORIC_MIRROR=ftp://tug.org/historic/ -t texlive .
```

By default, this will use the main [Historic archive of TeX material](https://tug.org/historic/) mirror, you may exchange it to any other mirror listed. 
If you intend to build these images yourself, it is recommended to make your own mirror or, if not possible, use a mirror near your physical location. 

## Building all images

To build all images, first build all the `none` docker images, then build the rest of the images.

To build the `none` images, use:

    bash build_none_images.sh

## Adding a new version

Adding a new version is probably only required once a year. 
To do so a new installation profile and remote url is required.

To get a new (default settings) profile, download the iso image by hand (e.g. by adapting a previous Dockerfile) and then run the following:

```bash
cd /installer/; echo i | perl ./install-tl -repository /installer/; cat /usr/local/texlive/*/tlpkg/texlive.profile
```

This creation process is also automated, see `utils/make_profile.sh`. 

## LICENSE

Released onto the public domain using the Unlicense. 
Please note that the images themselves cannot be released onto public domain; they are instead subject to the [LaTeX project public license](https://www.latex-project.org/lppl/).