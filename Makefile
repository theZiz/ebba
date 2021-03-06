#==stuff linked to
DYNAMIC = -lSDL_ttf -lSDL_mixer -lSDL_image -lSDL -lm
#==global Flags. Even on the gp2x with 16 kb Cache, -O3 is much better then -Os
CFLAGS = -O3 -fsingle-precision-constant -fPIC
# Testtweaks: -fgcse-lm -fgcse-sm -fsched-spec-load -fmodulo-sched -funsafe-loop-optimizations -Wunsafe-loop-optimizations -fgcse-las -fgcse-after-reload -fvariable-expansion-in-unroller -ftracer -fbranch-target-load-optimize
GENERAL_TWEAKS = -ffast-math
# GENERAL_TWEAKS += -DTRANSPARENCY
GENERAL_TWEAKS += -DNO_BLAS
# BLAS = -lblas
# BLAS = -lopenblas -L/usr/lib/openblas-base
# BLAS =  -L/usr/lib/atlas-base/atlas/ -lblas
#==PC==
FLAGS = -g -DDESKTOP $(GENERAL_TWEAKS)
SDL = `sdl-config --cflags`

SPARROW_FOLDER = ../sparrow3d

ifdef TARGET
include $(SPARROW_FOLDER)/target-files/$(TARGET).mk
BUILD = ./build/$(TARGET)/ebba
SPARROW_LIB = $(SPARROW_FOLDER)/build/$(TARGET)/sparrow3d
else
TARGET = "Default (change with make TARGET=otherTarget. See All targets with make targets)"
BUILD = .
SPARROW_LIB = $(SPARROW_FOLDER)
endif
LIB += -L$(SPARROW_LIB)
INCLUDE += -I$(SPARROW_FOLDER)
DYNAMIC += -lsparrow3d

CFLAGS += $(PARAMETER) $(FLAGS)

all: ebba
	@echo "=== Built for Target "$(TARGET)" ==="

targets:
	@echo "The targets are the same like for sparrow3d. :P"

ebba: ebba.c helpers.c defines.h phasenraum.c all.c matrix.c colour.c trace.c makeBuildDir
	cp $(SPARROW_LIB)/libsparrow3d.so $(BUILD)
	$(CC) $(CFLAGS) ebba.c $(SDL) $(INCLUDE) $(LIB) $(STATIC) $(DYNAMIC) $(BLAS) -o $(BUILD)/ebba

makeBuildDir:
	 @if [ ! -d $(BUILD:/ebba=/) ]; then mkdir $(BUILD:/ebba=/);fi
	 @if [ ! -d $(BUILD) ]; then mkdir $(BUILD);fi

clean:
	rm -f *.o
	rm -f ebba
	rm -f 2d-functions
