#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include </usr/local/include/nets/backprop.h>

int o;

static int not_here(char *s) { croak("%s not implemented on this architecture", s); return -1; }
static double constant(char *name, int len, int arg) { 
    errno = EINVAL; return 0; 
}

MODULE = AI::jNeural::nets::backprop PACKAGE = AI::jNeural::nets::backprop		

double
constant(sv,arg)
    PREINIT:
	STRLEN		len;
    INPUT:
	SV   * sv
	char * s = SvPV(sv, len);
	int arg
    CODE:
	RETVAL = constant(s, len, arg);
    OUTPUT:
	RETVAL

backprop *
backprop::new(alpha,inputs,outputs,hidden)
    double alpha
    int inputs
    int outputs
    int hidden
    int x = (inputs + outputs);
    int y = 1 + x;
    int z = x - 1;

    CODE:
    o = outputs;
    RETVAL = new backprop(alpha,inputs,outputs,hidden,x,y,z,x,y,z,x,y,z,x,y,z,x,y,z); // Cheap!!!!!!!!!!!

    OUTPUT:
    RETVAL


void 
backprop::set_transfer_function_for_output(i)
    int i

void 
backprop::set_transfer_function_for_hidden(i)
    int i

void 
backprop::set_input(input)
        char * input
        CODE:
        THIS->set_input( (double *) input );

void 
backprop::train_on(input)
        char * input
        CODE:
        THIS->train_on( (double *) input );

void 
backprop::test_on(input)
        char * input
        CODE:
        THIS->test_for( (double *) input );

void
backprop::reset_nmse()

double
backprop::query_nmse()

SV * 
backprop::query_output()
   PREINIT:
     double * d; 

   PPCODE:
     d = THIS->query_output();

     EXTEND(SP, o);
     for(int i=0; i<o; i++)
         PUSHs(sv_2mortal(newSVnv(d[i])));
