#include <stdio.h>
#include "libcxl.h"


int main(int argc, char *argv[])
{
	struct cxl_afu_h *afu;

	afu = cxl_afu_open_dev("/dev/cxl/afu0.0d");
	if(!afu)
	{
		printf("Failed to open AFU: %m\n");
		return 1;
	}

	cxl_afu_attach(afu, 0x0123456789abcdef);
	printf("Attached to AFU\n");

	cxl_afu_free(afu);

	return 0;
}
