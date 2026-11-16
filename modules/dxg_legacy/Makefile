# External-module scaffold. Invoke only against a configured Linux 6.18 source and build tree.
KSRC ?=
KDIR ?=

ifeq ($(strip $(KSRC)),)
$(error Set KSRC to the Linux source tree, for example KSRC=$$PWD/out/src/linux-6.18.63)
endif
ifeq ($(strip $(KDIR)),)
$(error Set KDIR to the configured Linux build directory, for example KDIR=$$PWD/out/build-armv5)
endif

all:
	$(MAKE) -C $(KSRC) O=$(KDIR) M=$(CURDIR) modules

clean:
	$(MAKE) -C $(KSRC) O=$(KDIR) M=$(CURDIR) clean
