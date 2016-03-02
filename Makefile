LIBCXL_PATH=~/workprojects/pslse/libcxl
LIBCXL_INCLUDE=-I $(LIBCXL_PATH) -L $(LIBCXL_PATH) -lcxl -lpthread
LIBRARIES=$(LIBCXL_INCLUDE)
CC=gcc -Wall -o $@ $< $(LIBRARIES) 

all: test_afu

test_afu: test_afu.c
	$(CC)

clean:
	rm -f test_afu
