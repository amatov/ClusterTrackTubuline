C++ = g++
CC = gcc
CFLAGS = -O3 -Wall -g
build = $(C++) $(CFLAGS) -o $@
touch = touch $@

.cc.o:
	$(C++) $(CFLAGS) -c $< -o $@

.c.o:
	$(C++) $(CFLAGS) -c $< -o $@

main_objects =  main.o \
		strio.o io.o profile.o \
		frames.o tracks.o criterion.o

goa_objects = 	goa.o
ipan_objects = 	ipan.o

targets = goa ipan

all: $(targets)

clean:
	rm -f $(main_objects) $(goa_objects) \
	      $(ipan_objects) $(targets)

goa: $(main_objects) $(goa_objects)
	$(build) $(main_objects) $(goa_objects) -lm

ipan: $(main_objects) $(ipan_objects)
	$(build) $(main_objects) $(ipan_objects) -lm

