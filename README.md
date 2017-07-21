# Pure Data icon

**Prelim: Up for Review**

This is a small repo for the Pure Data icon.

The makefile uses a master 1024x1025 file as a source for:

* macOS .icns icon set
* Windows .ico
* 256x256 .gif

You will need ImageMagick installed. The mac icon set can only be generated on a macOS system.

The icon was created using a Pd patch exported to PostScript. The PS file was then converted to SVG and tweaked in Inkscape.

The master files are:

* master/icon\_inkscape.svg: master Inkscape file
* master/icon.ps: PostScript export from Pd
* master/icon.svg: exported SVG from Inkscape
* master/icon2014.png: exported PNG from Inkscape
* master/patch: source Pd patches

