CC := gcc
XFLAGS := -Wall -std=c11 -D_POSIX_C_SOURCE=199309L
LIBRARIES := -levdev
INCLUDES := -I/usr/include/libevdev-1.0
CFLAGS := $(XFLAGS) $(LIBRARIES) $(INCLUDES)

OUTDIR := out
SOURCES := uinput.c input.c rce.c
OBJS := $(SOURCES:%.c=$(OUTDIR)/%.o)
TARGET := $(OUTDIR)/evdev-rce

.PHONY: all clean

$(OUTDIR)/%.o: %.c
	@mkdir -p $(OUTDIR)
	$(CC) $(CFLAGS) -c $< -o $@

$(TARGET): $(OBJS)
	$(CC) $(XFLAGS) $^ $(LIBRARIES) -o $@

all: $(TARGET)

build:
	: run make install
install:
	mkdir -p $(DESTDIR)/usr/bin
	cp -prfv $(OUTDIR)/evdev-rce $(DESTDIR)/usr/bin/rightclick
	mkdir -p $(DESTDIR)/etc/systemd/system
	cp -prfv rightclick.service  $(DESTDIR)/etc/systemd/system

	
clean:
	rm -rf $(OUTDIR)
