#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include </usr/local/include/utils/transfer.h>

static int
not_here(char *s)
{
    croak("%s not implemented on this architecture", s);
    return -1;
}

static double
constant_S(char *name, int len, int arg)
{
    switch (name[1 + 0]) {
    case 'I':
	if (strEQ(name + 1, "IGMOID")) {	/* S removed */
#ifdef SIGMOID
	    return SIGMOID;
#else
	    goto not_there;
#endif
	}
    case 'U':
	if (strEQ(name + 1, "UM")) {	/* S removed */
#ifdef SUM
	    return SUM;
#else
	    goto not_there;
#endif
	}
    }
    errno = EINVAL;
    return 0;

not_there:
    errno = ENOENT;
    return 0;
}

static double
constant(char *name, int len, int arg)
{
    errno = 0;
    switch (name[0 + 0]) {
    case 'B':
	if (strEQ(name + 0, "BIPOLAR")) {	/*  removed */
#ifdef BIPOLAR
	    return BIPOLAR;
#else
	    goto not_there;
#endif
	}
    case 'E':
	if (strEQ(name + 0, "ELLIOTT")) {	/*  removed */
#ifdef ELLIOTT
	    return ELLIOTT;
#else
	    goto not_there;
#endif
	}
    case 'J':
	if (strEQ(name + 0, "JBIPOLR")) {	/*  removed */
#ifdef JBIPOLR
	    return JBIPOLR;
#else
	    goto not_there;
#endif
	}
    case 'S':
	return constant_S(name, len, arg);
    case 'T':
	if (strEQ(name + 0, "TRANSFER_H")) {	/*  removed */
#ifdef TRANSFER_H
	    return 1;
#else
	    goto not_there;
#endif
	}
    }
    errno = EINVAL;
    return 0;

not_there:
    errno = ENOENT;
    return 0;
}


MODULE = AI::jNeural::utils::transfer		PACKAGE = AI::jNeural::utils::transfer		


double
constant(sv,arg)
    PREINIT:
	STRLEN		len;
    INPUT:
	SV *		sv
	char *		s = SvPV(sv, len);
	int		arg
    CODE:
	RETVAL = constant(s,len,arg);
    OUTPUT:
	RETVAL

double
xfer(to_xfer, type)
    double to_xfer
    int    type
    CODE:
        RETVAL = transfer(to_xfer, type);
        XSprePUSH; PUSHn((double)RETVAL);

double
xfer_dot(to_xfer, type)
    double to_xfer
    int    type
    CODE:
        RETVAL = transfer_dot(to_xfer, type);
        XSprePUSH; PUSHn((double)RETVAL);
