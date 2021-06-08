# texlive-docker

This repository contains docker images that contain a specific TexLive images.
They were originally intended for use with LaTeXML tests. 

Supported TexLive Versions:

- 2009

## Building

To build a docker image, simply `cd` into the directory of the corresponding year and use:

```
docker build --build-arg HISTORIC_MIRROR=ftp://tug.org/historic/ -t texlive .
```

By default, this will use the main [Historic archive of TeX material](https://tug.org/historic/) mirror, you may exchange it to any other mirror listed. 
If you intend to build these images yourself, it is recommended to make your own mirror or, if not possible, use a mirror near your physical location. 

## LICENSE

Released onto the public domain using the Unlicense. 
Please note that the images themselves cannot be released onto public domain; they are instead subject to the [LaTeX project public license](https://www.latex-project.org/lppl/).