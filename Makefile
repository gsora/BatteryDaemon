CC=/Applications/Xcode-beta.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang

SRCS=batterydaemon.m

OBJ-CFLAGS=-x objective-c -arch arm64 -arch armv7 -arch armv7s -fmessage-length=0 -fdiagnostics-show-note-include-stack -fmacro-backtrace-limit=0 -std=gnu99 -fobjc-arc -Wnon-modular-include-in-framework-module -Werror=non-modular-include-in-framework-module -Wno-trigraphs -fpascal-strings -O0 -fno-common -Wno-missing-field-initializers -Wno-missing-prototypes -Werror=return-type -Wunreachable-code -Wno-implicit-atomic-properties -Werror=deprecated-objc-isa-usage -Werror=objc-root-class -Wno-arc-repeated-use-of-weak -Wduplicate-method-match -Wno-missing-braces -Wparentheses -Wswitch -Wunused-function -Wno-unused-label -Wno-unused-parameter -Wunused-variable -Wunused-value -Wempty-body -Wconditional-uninitialized -Wno-unknown-pragmas -Wno-shadow -Wno-four-char-constants -Wno-conversion -Wconstant-conversion -Wint-conversion -Wbool-conversion -Wenum-conversion -Wshorten-64-to-32 -Wpointer-sign -Wno-newline-eof -Wno-selector -Wno-strict-selector-match -Wundeclared-selector -Wno-deprecated-implementations -DOBJC_OLD_DISPATCH_PROTOTYPES=0 -isysroot /Applications/Xcode-beta.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS9.0.sdk -fstrict-aliasing -Wprotocol -Wdeprecated-declarations -miphoneos-version-min=8.2 -Wno-sign-conversion

OBJ-CFLAGS-DEBUG=$(OBJ-CFLAGS) -DDEBUG=1 -g

.DEFAULT_GOAL := all

release: infinite.o
	$(CC) infinite.o $(OBJ-CFLAGS) $(SRCS) -o batterydaemon

infinite.o: infinite.m
	$(CC) $(OBJ-CFLAGS) -c infinite.m

debug: infinite.o
	$(CC) infinite.o $(OBJ-CFLAGS-DEBUG) $(SRCS) -o batterydaemon

.PHONY: clean
clean:
	rm -rf *.dSYM *o batterydaemon

.PHONY: all
all: debug
