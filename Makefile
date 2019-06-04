AS=as

LD=ld
LDFLAGS= --dynamic-linker /lib64/ld-linux-x86-64.so.2

all: env

debug: ASFLAGS += --gdwarf2
debug: LDFLAGS += -g
debug: env

env : env.o
	$(LD) $(LDFLAGS) env.o -o env -lc

.s.o:
	$(AS) $(ASFLAGS) $< -o $@

clean:
	rm env env.o
