package AI::jNeural::nets::backprop;
# $Id: backprop.pm,v 1.17 2002/06/26 14:55:48 jettero Exp $
# vi:fdm=marker fdl=0:

use strict;
use warnings;
use Carp;

# XS crap {{{
require 5.005_62;

require Exporter;
require DynaLoader;
use AutoLoader;

our @ISA         = qw(Exporter DynaLoader);
our %EXPORT_TAGS = ( 'all' => [ qw( ) ] );
our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );
our @EXPORT = qw( );
our $VERSION = '0.07';

sub AUTOLOAD {
    my $constname;
    our $AUTOLOAD;

    ($constname = $AUTOLOAD) =~ s/.*:://;

    croak "& not defined" if $constname eq 'constant';

    my $val = constant($constname, @_ ? $_[0] : 0);
    if ($! != 0) {
        if ($! =~ /Invalid/ || $!{EINVAL}) {
            $AutoLoader::AUTOLOAD = $AUTOLOAD;
            goto &AutoLoader::AUTOLOAD;
        } else {
            croak "Your vendor has not defined AI::jNeural::nets::backprop macro $constname";
        }
    }

    {
        no strict 'refs';
        # Fixed between 5.005_53 and 5.005_61
        if ($] >= 5.00561) {
            *$AUTOLOAD = sub () { $val };
        } else {
            *$AUTOLOAD = sub { $val };
        }
    }

    goto &$AUTOLOAD;
}

bootstrap AI::jNeural::nets::backprop $VERSION;
# }}}

return 1;

sub set_transfer {
    my ($this, $t) = @_;

    $this->set_transfer_function_for_output( $t );
    $this->set_transfer_function_for_hidden( $t );
}

sub train {
    my ($this, $training_inputs, $training_targets, $testing_inputs, $testing_targets, $epsilon, $max_epochs, $debug,
        $loops_per_epoch) = @_;

    if( ref($training_inputs) eq "HASH" ) {
        ($this, $training_inputs, $training_targets, $testing_inputs, $testing_targets, $epsilon, $max_epochs, $debug,
         $loops_per_epoch) = @{ $training_inputs }{qw(
                training_inputs training_targets
                 testing_inputs  testing_targets
                 epsilon alpha max_epochs debug
                 training_loops_per_epoch
            )},
    }

    my $error      = 0;
    my $min_error  = 30000;

    croak "dumb inputs"  unless ref($training_inputs)  eq "ARRAY";
    croak "dumb targets" unless ref($training_targets) eq "ARRAY";

    $epsilon = 0.01 unless $epsilon;
    $loops_per_epoch = 10 unless $loops_per_epoch;

    my $testing = ref($testing_targets) eq "ARRAY" and ref($testing_inputs) eq "ARRAY" ? 1:0;

    if( $debug ) {
        print STDERR "All training input sets:\n";
        for( 0..$#{ $training_inputs } ) {
            print STDERR "\t@{ $training_inputs->[$_] } ==> @{ $training_targets->[$_] }\n";
        }

        if( $testing ) {
            print STDERR "All testing input sets:\n";
            for( 0..$#{ $testing_inputs } ) {
                print STDERR "\t@{ $testing_inputs->[$_] } ==> @{ $testing_targets->[$_] }\n";
            }
        }
    }


    my @i1 = map(pack("d*", @$_), @$training_inputs);
    my @o1 = map(pack("d*", @$_), @$training_targets);

    my (@i2, @o2);
    if ($testing) {
        @i2 = map(pack("d*", @$_), @$testing_inputs);
        @o2 = map(pack("d*", @$_), @$testing_targets);
    }

    while( (not defined $max_epochs or --$max_epochs > 0) and $epsilon < $min_error ) {
        for (1..$loops_per_epoch-1) {
            for my $i (sort {rand cmp rand} 0..$#i1) {
                $this->set_input( $i1[$i] );
                $this->train_on(  $o1[$i] );
            }
        }

        $this->reset_nmse;

        for my $i (sort {rand cmp rand} 0..$#i1) {
            $this->set_input( $i1[$i] );
            $this->train_on(  $o1[$i] );
        }

        if( $testing ) {
            $this->reset_nmse;

            for my $i (0..$#i2) {
                $this->set_input( $i2[$i] );
                $this->test_on(   $o2[$i] );
            }
        }

        $error     = $this->query_nmse;
        $min_error = $error if $error < $min_error;

        printf STDERR q(error=%7.5f, min_error=%7.5f %s), $error, $min_error, "\n" if $debug;
    }

    return wantarray ? ($max_epochs, $min_error) : $min_error;
}

sub run {
    my ($this, $inputs) = @_;

    $this->set_input( pack("d*", @$inputs) );

    my @a = $this->query_output;

    return \@a;
}

__END__

=head1 NAME

AI::jNeural::nets::backprop - Backprop nets via libjneural

=head1 Synopsis

    This documentation blows.  This module is about half done, so relax. ;)
    Email feature requests, interface questions, angry emotive expressions, and 
    all other commetns to the author.

    Warning:  The interface can (and will) change at any time.  It will never do
    less than it does now, but the calls may change drastically over time.  Deal
    with it. ;)

=head1 new

    $the_net = new AI::jNeural::nets::backprop($alpha, $inputs, $outputs, $hidden);

    $alpha is the rate the weights are updated during back prop.
    $inputs is the number of inputs
    $outputs is the number of outputs
    $hidden is the number of hidden layers.

       How many nodes per hidden layer?  
       K, this is dumb, but I'm working on it.

       x = (outputs + inputs);
       y = x+1;
       y = x-1;

       The number of nodes in each hidden layer are x,y,z,x,y,z,x,y,z ...
       libjneural takes a variable number of args to new(), until I work out 
       the XS vararg format... this is how it will work. ;)


=head1 train

    This is a short cut method.  Well, it should be.  Presently it's the only
    interface for the training and testing methods.  If you wanted to
    personalize the training/testing then you'd need more methods.  Fred has
    asked for this very feature.  We're working on it.

    If I were you, I'd stick with the hashref interface (see below) since I'm
    likely to retire the array arguments soon.

    See below for what I hope is a realtively obvious calling syntax.

=head1 Example

   use AI::jNeural::nets::backprop;

    my $alpha = 0.92;
    my ($inputs, $outputs) = (1, 1);
    my $hidden = 2;
    my $the_net;
    my $debug = 0;
    my $epsilon    = 0.0007;  # this defaults to 0.01
    my $max_epochs = 8000;  # this actually defaults to infinity
     
    $the_net = new AI::jNeural::nets::backprop($alpha, $inputs, $outputs, $hidden);

    # There is also BIPOLAR (among others iirc)
    $the_net->set_transfer(SIGMOID);

    
    # training data
    for my $n (0.1, 0.3, 0.5, 0.7, 0.9) {
        push @$sin_i1, [ $n ];
        push @$sin_o1, [ sin($n) ];
    }

    # test data
    for my $n (0.0, 1.12, 0.44, 0.85) {
        push @$sin_i2, [ $n ];
        push @$sin_o2, [ sin($n) ];
    }

    my ($min_error, $epochs_left) = 
        $the_net->train( $sin_i1, $sin_o1, $sin_i2, 
            $sin_o2, $epsilon, $max_epochs, $debug );

    # This may not be quite clear say there were 3 inputs and 2 outputs, then
    #
    # $in  = [ [1, 2, 3], [4, 5, 6], [7, 8, 9] ];
    # $out = [ [1, 2],    [3, 4],    [5, 6]    ];
    #
    # Follow?
    #
    # In any case, if you leave the test array_refs as undef's, then only the
    # training data will be used.

    # oh, and the above could have been:

    $the_net->train({
        training_inputs => $sin_i1,
         testing_inputs => $sin_i2,

        training_targets => $sin_o1,
         testing_targets => $sin_o2,

         epsilon=>$epsilon, alpha=>$alpha, max_epochs=>$max_epochs,

         debug=>1,

         training_loops_per_epoch => 10, 
             # defaults to 10
             # It's the number of times it trains on data before
             # it calculates an nmse and compares with the epsilon
    });

=head1 AUTHOR

Jettero Heller <jettero@voltar.org>

Jet's Neural Architecture is a C++ library.
<http://www.voltar.org/jneural>

=head1 SEE ALSO

perl(1), AI::jNeural(3), AI::jNeural::arch::neuron(3), AI::jNeural::arch(3), AI::jNeural::nets::backprop(3), AI::jNeural::nets(3), AI::jNeural::nets::kohonen(3), AI::jNeural::nets::sarsa(3), AI::jNeural::utils::transfer(3), AI::jNeural::utils(3).

=cut
