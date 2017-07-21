UNAME = $(shell uname)

NAME=pd
SRC_PNG=masters/icon1024.png

ICO=$(NAME).ico

ICNS=$(NAME).icns
ICONSET=$(NAME).iconset

GIF=$(NAME).gif

.PHONY: clean

all: $(ICO) $(ICNS) $(GIF)

# Windows ico
$(ICO): $(SRC_PNG)
	convert $(SRC_PNG) -define icon:auto-resize=256,128,64,48,32,16 $(ICO)

# macOS iconset
ifeq ($(UNAME), Darwin) 
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
else
$(ICNS): $(SRC_PNG)
	echo "$(ICNS) can only be generated on macOS"
endif

# gif for loading via Tk on Linux, etc
$(GIF): $(SRC_PNG)
	convert $(SRC_PNG) -resize 256 $(GIF)

clean:
	rm -f $(ICO) $(ICNS) $(ICONSET) $(GIF)
