END { 
    if($loaded) {
        print "loaded ok.\n";
    } else {
        print "not ok 1.\n";
    }
}

use AI::jNeural::utils::transfer qw/:types/; 

$loaded = 1;

print "xfer(0.5, SUM)     = ", AI::jNeural::utils::transfer::xfer(0.5, SUM),     "\n";
print "xfer(0.5, SIGMOID) = ", AI::jNeural::utils::transfer::xfer(0.5, SIGMOID), "\n";
print "xfer(0.5, BIPOLAR) = ", AI::jNeural::utils::transfer::xfer(0.5, BIPOLAR), "\n";
print "xfer(0.5, JBIPOLR) = ", AI::jNeural::utils::transfer::xfer(0.5, JBIPOLR), "\n";
print "xfer(0.5, ELLIOTT) = ", AI::jNeural::utils::transfer::xfer(0.5, ELLIOTT), "\n";
