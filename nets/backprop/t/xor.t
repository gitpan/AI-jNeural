# vi:fdm=marker fdl=0 syntax=perl:
# $Id: xor.t,v 1.4 2002/06/19 20:56:26 jettero Exp $

use strict;
use Test;

plan tests => 7;

print STDERR " loading\n"; 
use AI::jNeural::nets::backprop; 
use AI::jNeural::utils::transfer qw(:types);
ok 1;

my $alpha = 0.92;
my ($inputs, $outputs) = (2, 1);
my $hidden = 1;
my $the_net;
my $debug = 0;

print STDERR " new\n";
ok $the_net = new AI::jNeural::nets::backprop($alpha, $inputs, $outputs, $hidden);

my $xor_i = [ [ 0, 0 ], [ 1, 1 ], [ 0, 1 ], [ 1, 0 ] ];
my $xor_o = [ [ 0 ],    [ 0 ],    [ 1 ],    [ 1 ]    ];

my $epsilon    = 0.01;
my $max_epochs = 4000;

$the_net->set_transfer(SIGMOID);

print STDERR " training for xor\n"; 
my @a = $the_net->train( $xor_i, $xor_o, $epsilon, $max_epochs, $debug );
ok $epsilon >= $a[1];

$a[0] = 4000 - $a[0];

print STDERR " $a[0] epochs, min_error: $a[1]\n";

my $v;

ok 0.5 >= ($v = $the_net->run([ 0, 0 ])->[0]);  print STDERR " xor(0,0) = $v\n";
ok 0.5 <= ($v = $the_net->run([ 0, 1 ])->[0]);  print STDERR " xor(0,1) = $v\n";
ok 0.5 <= ($v = $the_net->run([ 1, 0 ])->[0]);  print STDERR " xor(1,0) = $v\n";
ok 0.5 >= ($v = $the_net->run([ 1, 1 ])->[0]);  print STDERR " xor(1,1) = $v\n";

__END__

[0,0, 0.0721] [0,1, 0.9161] [1,0, 0.9047] [1,1, 0.1318]   E=0.010221925

    0 xor 0 = 0
    0 xor 1 = 1
    1 xor 0 = 1
    1 xor 1 = 0

These are rounded values:


Average Error  = 1.0%
Number of Epochs = 1630

