# texlive-docker

This repository contains docker images that contain a specific TexLive images.
They were originally intended for use with LaTeXML tests. 

Supported TexLive Versions:

- 2008
- 2009

## Building

To build a docker image, simply `cd` into the directory of the corresponding year and use:

```
docker build --build-arg HISTORIC_MIRROR=ftp://tug.org/historic/ -t texlive .
```

By default, this will use the main [Historic archive of TeX material](https://tug.org/historic/) mirror, you may exchange it to any other mirror listed. 
If you intend to build these images yourself, it is recommended to make your own mirror or, if not possible, use a mirror near your physical location. 


## Adding a new version

Adding a new version is probably only required once a year. 
To do so a new installation profile and remote url is required.

To get a new (default settings) profile, download the iso image by hand (e.g. by adapting a previous Dockerfile) and then run the following:

```bash
cd /installer/; echo i | perl ./install-tl -repository /installer/; cat /usr/local/texlive/*/tlpkg/texlive.profile
```

## LICENSE

Released onto the public domain using the Unlicense. 
Please note that the images themselves cannot be released onto public domain; they are instead subject to the [LaTeX project public license](https://www.latex-project.org/lppl/).