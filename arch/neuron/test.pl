END { 
    if($loaded) {
        print "loaded ok.\n";
    } else {
        print "not ok 1.\n";
    }
}

use AI::jNeural::arch::neuron; $loaded = 1;

my @neurons = ();

push @neurons, 
    new AI::jNeural::arch::neuron("Neuron #$_")
        for(1..3);

for(0..$#neurons) {
    print "uber-cool test: ", $neurons[$_], " is ", $neurons[$_]->query_name, "\n";
}

$neurons[0]->dendrites_touch( @neurons[1..$#neurons] );

foreach( [0, 1], [1, 0], [1, 0], [0, 1] ) {
    $neurons[1]->set_input( $_->[0] );
    $neurons[2]->set_input( $_->[1] );

    print "output: ", $neurons[0]->query_output(), "\n";
}
