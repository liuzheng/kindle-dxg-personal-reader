# External-module scaffold. Invoke only against a configured Linux 6.18 build tree.
KDIR ?=

ifeq ($(strip $(KDIR)),)
$(error Set KDIR to a configured Linux build directory, for example KDIR=$$PWD/out/build-armv5)
endif

all:
	$(MAKE) -C $(KDIR) M=$(CURDIR) modules

clean:
	$(MAKE) -C $(KDIR) M=$(CURDIR) clean
