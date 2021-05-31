#
# Dan Wilcox <danomatika@gmail.com> 2017
# Max Neupert 2021
# 

UNAME = $(shell uname)

NAME=pd
SRC_PNG=masters/icon1024.png
SRC_PNG_FILE=masters/GenericDocumentIcon.png
SRC_SVG=masters/icon.svg

ICO=$(NAME).ico

ICNS=$(NAME).icns
ICONSET=$(NAME).iconset

FILE=$(NAME)-file.png
ICNS_FILE=$(NAME)-file.icns
ICONSET_FILE=$(NAME)-file.iconset

GIF=$(NAME).gif
XPM=$(NAME).xpm

.PHONY: clean

all: $(ICO) $(ICNS) $(ICNS_FILE) $(GIF)

# Windows ico
$(ICO): $(SRC_PNG)
	convert $(SRC_PNG) -define icon:auto-resize=256,128,64,48,32,16 $(ICO)

# shrink & composite over default macOS file icon
$(FILE): $(SRC_PNG)
	convert $(SRC_PNG_FILE) \( $(SRC_PNG) -resize 512 \) \
	        -gravity center -geometry +0+0 -composite $(FILE)

# macOS iconsets
ifeq ($(UNAME), Darwin) 

# app icon
$(ICNS): $(SRC_PNG)
	mkdir $(ICONSET)
	sips -z 16 16     $(SRC_PNG) --out $(ICONSET)/icon_16x16.png
	sips -z 32 32     $(SRC_PNG) --out $(ICONSET)/icon_16x16@2x.png
	sips -z 32 32     $(SRC_PNG) --out $(ICONSET)/icon_32x32.png
	sips -z 64 64     $(SRC_PNG) --out $(ICONSET)/icon_32x32@2x.png
	sips -z 128 128   $(SRC_PNG) --out $(ICONSET)/icon_128x128.png
	sips -z 256 256   $(SRC_PNG) --out $(ICONSET)/icon_128x128@2x.png
	sips -z 256 256   $(SRC_PNG) --out $(ICONSET)/icon_256x256.png
	sips -z 512 512   $(SRC_PNG) --out $(ICONSET)/icon_256x256@2x.png
	sips -z 512 512   $(SRC_PNG) --out $(ICONSET)/icon_512x512.png
	cp                $(SRC_PNG)       $(ICONSET)/icon_512x512@2x.png
	iconutil -c icns $(ICONSET)
	rm -rf $(ICONSET)

# document icon
$(ICNS_FILE): $(FILE)
	mkdir $(ICONSET_FILE)
	sips -z 16 16     $(FILE) --out $(ICONSET_FILE)/icon_16x16.png
	sips -z 32 32     $(FILE) --out $(ICONSET_FILE)/icon_16x16@2x.png
	sips -z 32 32     $(FILE) --out $(ICONSET_FILE)/icon_32x32.png
	sips -z 64 64     $(FILE) --out $(ICONSET_FILE)/icon_32x32@2x.png
	sips -z 128 128   $(FILE) --out $(ICONSET_FILE)/icon_128x128.png
	sips -z 256 256   $(FILE) --out $(ICONSET_FILE)/icon_128x128@2x.png
	sips -z 256 256   $(FILE) --out $(ICONSET_FILE)/icon_256x256.png
	sips -z 512 512   $(FILE) --out $(ICONSET_FILE)/icon_256x256@2x.png
	sips -z 512 512   $(FILE) --out $(ICONSET_FILE)/icon_512x512.png
	cp                $(FILE)       $(ICONSET_FILE)/icon_512x512@2x.png
	iconutil -c icns $(ICONSET_FILE)
	rm -rf $(ICONSET_FILE)

else

$(ICNS): $(SRC_PNG)
	echo "$(ICNS) can only be generated on macOS"

$(ICNS_FILE): $(SRC_PNG)
	echo "$(ICNS_FILE) can only be generated on macOS"

endif

# gif for loading via Tk on Linux, etc
$(GIF): $(SRC_PNG)
	convert $(SRC_PNG) -filter box -resize 512 $(GIF)

# xpm for X11 on Linux
# this get's it close enough to be adjusted by hand
$(XPM): $(SRC_PNG)
	convert $(SRC_PNG) -filter box -resize 32 $(XPM)

# generate pngs from SVG directly using inkscape
inkscape:
	for _res in 16 32 48 64 96 128 256 512 ; do \
		 inkscape --export-type="png" --export-filename=pd-$${_res}.png --export-width $${_res} --export-height $${_res} $(SRC_SVG) ; \
	done

# register icon for Pd mimetype (adapted from https://stackoverflow.com/a/31836/1964109 )
mime-register:
	xdg-icon-resource install --context mimetypes --size 512 pd-512.png x-puredata
	xdg-mime install x-puredata.xml
	cp pd-gui.desktop ~/.local/share/applications/pd-gui.desktop

# 	following https://hoppenheit.info/blog/2016/where-to-put-application-icons-on-linux/
install:
	cp tweaked/pd.xpm /usr/share/pixmaps/puredata.xpm
	cp pd-48.png /usr/share/icons/hicolor/48x48/apps/puredata.png
	cp masters/icon.svg /usr/share/icons/hicolor/scalable/apps/puredata.svg

clean:
	rm -f $(ICO) $(FILE) $(ICNS) $(ICONSET) $(GIF) $(XPM) pd-*.png
