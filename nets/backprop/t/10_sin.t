# vi:fdm=marker fdl=0 syntax=perl:
# $Id: 10_sin.t,v 1.3 2002/06/25 17:55:30 jettero Exp $

use strict;
use Test;

plan tests => 4;

print STDERR " training\n"; 
use AI::jNeural::nets::backprop; 
use AI::jNeural::utils::transfer qw(:types);

my $alpha = 0.92;
my ($inputs, $outputs) = (1, 1);
my $hidden = 2;
my $the_net;
my $debug = 0;
my $epsilon    = 0.0008;
my $max_epochs = 7000;

$the_net = new AI::jNeural::nets::backprop($alpha, $inputs, $outputs, $hidden);
$the_net->set_transfer(SIGMOID);

my ($sin_i1, $sin_o1, $sin_i2, $sin_o2);

for my $n (0.1, 0.3, 0.5, 0.7, 0.9) {
    push @$sin_i1, [ $n ];
    push @$sin_o1, [ sin($n) ];
}

for my $n (0.0, 1.12, 0.44, 0.85) {
    push @$sin_i2, [ $n ];
    push @$sin_o2, [ sin($n) ];
}

my @a = $the_net->train( $sin_i1, $sin_o1, $sin_i2, $sin_o2, $epsilon, $max_epochs, $debug );
ok $epsilon >= $a[1];

$a[0] = $max_epochs - $a[0];

print STDERR " $a[0] epochs, min_error: $a[1]\n";

my ($x, $v);

ok (($x = sprintf "%0.1f", sin(0.6)) eq ($v = sprintf "%0.1f", $the_net->run([ 0.6 ])->[0]));print STDERR " sin(0.6) = $x =? $v\n";
ok (($x = sprintf "%0.1f", sin(1.0)) eq ($v = sprintf "%0.1f", $the_net->run([ 1.0 ])->[0]));print STDERR " sin(1.0) = $x =? $v\n";
ok (($x = sprintf "%0.1f", sin(1.2)) eq ($v = sprintf "%0.1f", $the_net->run([ 1.2 ])->[0]));print STDERR " sin(1.2) = $x =? $v\n";

__END__

[0,0, 0.0721] [0,1, 0.9161] [1,0, 0.9047] [1,1, 0.1318]   E=0.010221925

    0 xor 0 = 0
    0 xor 1 = 1
    1 xor 0 = 1
    1 xor 1 = 0

These are rounded values:


Average Error  = 1.0%
Number of Epochs = 1630

