END { 
    if($loaded) {
        print "loaded ok.\n";
    } else {
        print "not ok 1.\n";
    }
}

use AI::jNeural::nets::kohonen; $loaded = 1;

$radius  = 0;
$epsilon = 0.00001;

@matrix  = (
    [1, 1, 0, 0],
    [1, 0, 0, 0],
    [0, 0, 0, 1],
    [0, 0, 1, 1],
);

$the_net = new AI::jNeural::nets::kohonen(0.9, 4, 2);
{
    foreach $row ( @matrix ) {
        set_input     $the_net @$row;
        linear_train  $the_net $radius;
    }
    redo if update_learning_rate $the_net > $epsilon;
}

foreach $row ( @matrix ) {
    $the_net->set_input(@$row); 

    $max = $the_net->query_max_output;

    print "[" . (join ", ", @$row) . "] was put in group $max.\n";
}
