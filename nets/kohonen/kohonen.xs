#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include </usr/local/include/nets/kohonen.h>

static int not_here(char *s) { croak("%s not implemented on this architecture", s); return -1; }
static double constant(char *name, int len, int arg) { errno = EINVAL; return 0; }

MODULE = AI::jNeural::nets::kohonen		PACKAGE = AI::jNeural::nets::kohonen		

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

kohonen *
kohonen::new(alpha, inputs, outputs)
        double alpha
        int    inputs
        int    outputs

void 
kohonen::_set_input(input)
        char * input
        CODE:
        THIS->set_input( (double *) input );

void
kohonen::linear_train(radius)
        int radius

void
kohonen::rectangular_train(radius)
        int radius

double
kohonen::_update_learning_rate_g(gamma)
        double gamma
        CODE:
            RETVAL = THIS->update_learning_rate();
            XSprePUSH; PUSHn((double)RETVAL);

double
kohonen::_update_learning_rate()
        CODE:
            RETVAL = THIS->update_learning_rate();
            XSprePUSH; PUSHn((double)RETVAL);

double
kohonen::query_max_output()
