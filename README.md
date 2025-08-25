# texlive-docker

This repository contains docker images that contain a specific TexLive and Perl versions.
Newer images are based on debian trixe, older images are based on older Debian Versions.
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
- TeXLive 2021, Perl 5.34
- TexLive 2022, Perl 5.36
- TexLive 2023, Perl 5.38
- TexLive 2024, Perl 5.38
- TexLive 2025, Perl 5.42
- No TeXLive, Perl 5.10 - 5.42 (see below)

## Images

The Images are available at [ghcr.io/tkw1536/texlive-docker](ghcr.io/tkw1536/texlive-docker). 
The supported tags are `${texlive}-${perl}`, for instance: `ghcr.io/tkw1536/texlive-docker:2021-5.34` will give you TeXLive 2021 with perl 5.34.
Not all combinations are available, see the list below for available images.

Versions With TeXLive available:
- `2025-5.42.0`, `2025-5.42`, `2025-5`, `2025`, `latest`
- `2024-5.38.4`, `2024-5.38`, `2024-5`, `2024`
- `2023-5.38.4`, `2023-5.38`, `2023-5`, `2023`
- `2022-5.36.3`, `2022-5.36`, `2022-5`, `2022`
- `2021-5.34.3`, `2021-5.34`, `2021-5`, `2021`
- `2020-5.32.1`, `2020-5.32`, `2020-5`, `2020`
- `2019-5.30.3`, `2019-5.30`, `2019-5`, `2019`
- `2018-5.28.3`, `2018-5.28`, `2018-5`, `2018`
- `2017-5.26.3`, `2017-5.26`, `2017-5`, `2017`
- `2016-5.24.4`, `2016-5.24`, `2016-5`, `2016`
- `2015-5.22.4`, `2015-5.22`, `2015-5`, `2015`
- `2014-5.20.3`, `2014-5.20`, `2014-5`, `2014`
- `2013-5.18.4`, `2013-5.18`, `2013-5`, `2013`
- `2012-5.16.3`, `2012-5.16`, `2012-5`, `2012`
- `2011-5.14.4`, `2011-5.14`, `2011-5`, `2011`
- `2010-5.12.5`, `2010-5.12`, `2010-5`, `2010`
- `2009-5.10.1`, `2009-5.10`, `2009-5`, `2009`
- `2008-5.10.1`, `2008-5.10`, `2008-5`, `2008`

Perl Only Tags:
 - `none-5.42.0`, `none-5.42`, `none-5`, `none`
 - `none-5.40.2`, `none-5.40`
 - `none-5.38.4`, `none-5.38`
 - `none-5.36.3`, `none-5.36`
 - `none-5.34.3`, `none-5.34`
 - `none-5.34.3`, `none-5.34`
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

To build a single docker image, simply `cd` into the directory of the corresponding year and use:

```
docker build --build-arg PERL_VERSION=perl-5.10.1 --build-arg HISTORIC_MIRROR=ftp://tug.org/historic/ -t texlive .
```

or for an image with only perl:

```
docker build --build-arg PERL_VERSION=perl-5.10.1 -t texlive:none-5.10.1 .
```

By default, this will use the main [Historic archive of TeX material](https://tug.org/historic/) mirror, you may exchange it to any other mirror listed. 
If you intend to build these images yourself, it is recommended to make your own mirror or, if not possible, use a mirror near your physical location. 

## Building all images

To build all images, first build all the `none` docker images, then build the rest of the images.

To build the `none` images, use:

    bash build_none_images.sh

To build the `texlive` images, use:

    bash build_tex_images.sh

Be warned that either can take up several gigabytes of space per image.
It is not recommended to run these scripts without modification, instead modify them to only build and push the images you want.

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
