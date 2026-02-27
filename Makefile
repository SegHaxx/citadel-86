TARGETS+=Citadel-86_Boot_360k.img
TARGETS+=Citadel-86_Data_360k.img
TARGETS+=Citadel-86_1.44.img

all: $(TARGETS)

CTDLBAT=src/bat/init.bat src/bat/runit.bat src/bat/fixit.bat
CTDLBIN=src/CONFG.EXE src/CTDL.EXE src/C86DOOR.EXE
CTDLEASE=ease/ease.exe ease/ease.hlp ease/ease2.hlp ease/modems

# Unpack Borland compiler

BORLAND=bin/Borland_C++_3.1

.INTERMEDIATE: $(BFLAG)
BFLAG=$(BORLAND)/.extracted

$(BFLAG):
	@7za x $(BORLAND).7z -o$(BORLAND)
	@touch $(BFLAG)

# Build Citadel-86 in DOSBox

.PHONY: dosbox

DOSBOX=flatpak run com.dosbox_x.DOSBox-X
DOSBOX+=-nolog -fastlaunch -defaultconf -conf dosbox.conf

$(CTDLBIN): $(BFLAG)
	$(DOSBOX) -c make -c exit

.PHONY: bmakeclean

bmakeclean: $(BFLAG)
	$(DOSBOX) -c "make clean" -c exit

.PHONY: dosshell

dosshell:
	$(DOSBOX)

# UPX pack for floppy images

CTDLUPX=release/upx/confg.exe release/upx/ctdl.exe release/upx/c86door.exe
CLEANTARGETS+=$(CTDLUPX)

release/upx/confg.exe: src/CONFG.EXE
	@rm -f $@
	upx --best --8086 $< -o$@
	@touch $@

release/upx/ctdl.exe: src/CTDL.EXE
	@rm -f $@
	upx --best --8086 $< -o$@
	@touch $@

release/upx/c86door.exe: src/C86DOOR.EXE
	@rm -f $@
	upx --best --8086 $< -o$@
	@touch $@

# Make bootable floppy images

DIST+=bin/edit.com
DIST+=release/autoexec.bat

DIST360+=$(DIST) release/360k/readme.txt
DIST144+=$(DIST) release/1.44/readme.txt
DIST360+=$(CTDLBAT) $(CTDLUPX) release/360k/ctdlcnfg.sys
DIST144+=$(CTDLBAT) $(CTDLBIN) $(CTDLEASE) help/ release/1.44/ctdlcnfg.sys

Citadel-86_1.44.img: $(DIST144)
	@cp bin/svardos144.img $@
	mcopy -m -i $@ $^ ::/

Citadel-86_Boot_360k.img: $(DIST360)
	@cp bin/svardos360.img $@
	mcopy -m -i $@ $^ ::/

# Just a blank image
Citadel-86_Data_360k.img:
	@-rm -f $@
	@truncate -s 360k $@
	mformat -f 360 -i $@

.PHONY: clean

clean:
	-rm -rf $(TARGETS) $(CLEANTARGETS)

distclean: clean bmakeclean
	-rm -rf $(BORLAND)
	find . -type f -iname \*~ -print0|xargs -0 rm -f

