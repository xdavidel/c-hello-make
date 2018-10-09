# Object files to create for the executable
OBJS = obj/main.o

# Warnings to be raised by the C compiler
WARNS = -Wall

# Names of tools to use when building
CC = gcc -g
EXE = main

# Compiler flags. Compile ANSI build only if CHARSET=ANSI.
ifeq (${CHARSET}, ANSI)
  CFLAGS = -O2 -D _WIN32_IE=0x0500 -D WINVER=0x0500 ${WARNS} -Iinclude
else
  CFLAGS = -O2 -D UNICODE -D _UNICODE -D _WIN32_IE=0x0500 -D WINVER=0x0500 ${WARNS} -Iinclude
endif

# Linker flags
LDFLAGS = -W

.PHONY: all clean

# Build executable by default
all: executable

# strip symbols for release
release: LDFLAGS += -s
release: executable

executable: bin/${EXE}

# Delete all build output
clean:
	if [ -f bin/${EXE} ];  then rm bin/${EXE}; fi
	if [ -f obj/* ];  then rm obj/*; fi

# Create build output directories if they don't exist
bin obj:
	if [ ! -d "$@" ]; then echo "exists"; else mkdir "$@"; fi

# Compile object files for executable
obj/%.o: src/%.c | obj
	${CC} ${CFLAGS} -c "$<" -o "$@"

# Build the exectuable
bin/${EXE}: ${OBJS} | bin
	${CC} -o "$@" ${OBJS} ${LDFLAGS}

# C header dependencies
obj/main.o: include/greeting.h