O_ARCH = cortexa9-vfpv3
O_YEAR = 2021.0
O_REPO = main

# OPKG Sources
CFFI_SRC = https://download.ni.com/ni-linux-rt/feeds/$(O_YEAR)/arm/$(O_REPO)/$(O_ARCH)/libffi6_3.2.1-r0.465_$(O_ARCH).ipk

BUILDDR = _build
BINDIR = $(BUILDDR)/bin
DISTDIR = _dist

# Specific files
CFFI_PKG = ${BUILDDR}/libffi-latest.ipk

all: package

.PHONY: fetch
fetch:
	mkdir -p ${BINDIR}

	wget ${CFFI_SRC} -O ${CFFI_PKG}

.PHONY: package
package: fetch
	ar x ${CFFI_PKG} --output ${BUILDDR}
	tar -xvf ${BUILDDR}/*.xz -C ${BUILDDR}
	# Dont crack control data for rn

	mkdir -p ${BINDIR}/usr/local/lib
	cp -rH ${BUILDDR}/usr/lib/* ${BINDIR}/usr/local/lib

	# This file causes errors with roborio-gen-whl, TODO: Find out why.
	rm ${BINDIR}/usr/local/lib/libffi.so.6.0.4

	# Create release
	roborio-gen-whl data.py ${BINDIR} -o ${DISTDIR}

	# Create dev (todo)

clean:
	git clean -fdX
