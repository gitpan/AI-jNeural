#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include <stdarg.h>

#include </usr/local/include/nets/sarsa.h>

int o;

static int not_here(char *s) { croak("%s not implemented on this architecture", s); return -1; }
static double constant(char *name, int len, int arg) { 
    errno = EINVAL; return 0; 
}

MODULE = AI::jNeural::nets::sarsa PACKAGE = AI::jNeural::nets::sarsa		

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

sarsa *
sarsa::new(alpha,lambda,gamma,inputs,outputs,hidden)
    double alpha
    double lambda
    double gamma
    int inputs
    int outputs
    int hidden
    int x = (inputs + outputs);
    int y = 1 + x;
    int z = x - 1;

    CODE:
    o = outputs;
    RETVAL = new sarsa(alpha,lambda,gamma,inputs,outputs,hidden,x,y,z,x,y,z,x,y,z,x,y,z,x,y,z); // Cheap!!!!!!!!!!!

    OUTPUT:
    RETVAL

void 
sarsa::set_transfer_function_for_output(i)
    int i

void 
sarsa::set_transfer_function_for_hidden(i)
    int i

void
sarsa::reinitialize_weights_with(max,min)
    double max
    double min

void
sarsa::start_new_episode()

void
sarsa::_set_state(input)
    char * input
    CODE:
    THIS->set_state( (double *) input );

int
sarsa::query_action()

void
sarsa::set_action(action)
    int action

void
sarsa::learn_from_final(reward)
    double reward

void
sarsa::learn_from(reward)
    double reward
