# vi:fdm=marker fdl=0 syntax=perl:
# $Id: 00_walker.t,v 1.2 2002/12/10 16:22:48 jettero Exp $

use strict;
use Test;
use Math::Business::SMA; my $sma = new Math::Business::SMA; $sma->set_days(7);

plan tests => 6; 

use AI::jNeural::nets::sarsa; 
use AI::jNeural::utils::transfer qw(:types);
ok 1;

my ($max_weights, $min_weights)        = (1.0, -1.0);
my ($alpha, $gamma, $lambda)           = (0.07, 1.0, 0.8);
my ($states, $actions, $hidden_layers) = (10, 2, 7);

my $sarsa = new AI::jNeural::nets::sarsa($alpha, $lambda, $gamma, $states, $actions, $hidden_layers); ok 1;

$sarsa->reinitialize_weights_with($max_weights, $min_weights); ok 1;
$sarsa->set_transfer_function_for_output(BIPOLAR); ok 1;
$sarsa->set_transfer_function_for_hidden(BIPOLAR); ok 1;

sleep 2;  # so you can see the other tests...

my ($total_reward, $avg) = (0,0);
for my $episode (1..50) {
    my $state = int(2 + ($states-2)*rand);
    $sarsa->start_new_episode; 
    $sarsa->set_state(show_state($state, $episode));

    my $action = $sarsa->query_action;
    $sarsa->set_action( $action );
    $state += ($action ? 1 : -1);

    my $max_epochs = 500;
    for my $epoch (1..$max_epochs) {
        $sarsa->set_state(show_state($state, $episode));
        $action = $sarsa->query_action;
        $action = int(2*rand) unless int($states*rand);  # pure random epsilon test
        $sarsa->set_action( $action );
        $state += ($action ? 1 : -1);

        if( $state < 1 ) {
            $sarsa->learn_from_final( -1 ); # bad side
            $total_reward -= 1;
            last;
        } elsif( $state > $states ) {
            $sarsa->learn_from_final( 1 ); # good side
            $total_reward += 1;
            last;
        } elsif( $epoch == $max_epochs ) {
            $sarsa->learn_from_final( -1 ); # max epochs suck
            $total_reward -= 1;
            last;
        } else { # note, no _final below
            $sarsa->learn_from( -0.1 ); # gotta wander to find the ends...
            $total_reward -= 0.1;
        }
    }

    $sma->insert($total_reward);
    $avg = $sma->query; 
    $avg = 0 unless $avg; # an sma() is undefined until there's enough episodes.
    print STDERR "\nTotal: $total_reward, sma(10) is $avg\n";
    $total_reward = 0;

    last if $avg > 0;
}

print STDERR "\nNote:  Test 6 does sometimes fail... which is correct; simply try the test again.\n\n" unless $avg > 0;

ok $avg > 0;

sub show_state {
    my $state = shift;
    my $episode = shift;

    my @a = ();

    for(1..$states) {
        push @a, ($_ == $state ? 1 : 0);
    }

    my @b = map(($_ ? "X" : " "), @a);

    print STDERR " bad side [@b] good side    episode $episode\n";

    return \@a;
}
