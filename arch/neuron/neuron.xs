#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include </usr/local/include/arch/neuron.h>

static int
not_here(char *s)
{
    croak("%s not implemented on this architecture", s);
    return -1;
}

static double
constant(char *name, int len, int arg)
{
    errno = 0;
    if (strEQ(name + 0, "NEURON_H")) {	/*  removed */
#ifdef NEURON_H
	return 1;
#else
	errno = ENOENT;
	return 0;
#endif
    }
    errno = EINVAL;
    return 0;
}

MODULE = AI::jNeural::arch::neuron		PACKAGE = AI::jNeural::arch::neuron		

double
constant(sv,arg)
    PREINIT:
	STRLEN		len;
    INPUT:
	SV   *		sv
	char *		s = SvPV(sv, len);
	int		arg
    CODE:
	RETVAL = constant(s,len,arg);
    OUTPUT:
	RETVAL

neuron *
neuron::new(NAME)
    char * NAME

void
neuron::DESTROY()

char *
neuron::query_name()

void
neuron::dendrites_touch(...)
    CODE:
        int num_n = items-1;
        printf("neurons: %i\n", num_n);

        for(int i=1; i<=num_n; i++) // This is a terrible waste... oh well.
            THIS->dendrites_touch(1, (neuron *) SvIV( (SV*) SvRV( ST(i) ) ) );

double
neuron::query_input()

double
neuron::query_output()

double
neuron::query_output_dot()

void
neuron::set_input(d)
    double d
