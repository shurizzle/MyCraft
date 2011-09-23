HOST ?= craft.dre.am

all:
	@echo CC -DHOST='"$(HOST)"' getaddrfake
	@$(CC) -nostartfiles -fPIC -shared '-DHOST="$(HOST)"' getaddrfake.c -o getaddrfake.so -ldl
