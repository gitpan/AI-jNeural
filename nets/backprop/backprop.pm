package AI::jNeural::nets::backprop;
# $Id: backprop.pm,v 1.12 2002/06/20 12:22:20 jettero Exp $
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
our $VERSION = '0.06';

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
    my ($this, $inputs, $targets, $epsilon, $max_epochs, $debug) = @_;

    my $error     = 0;
    my $min_error = 30000;

    croak "dumb inputs"  unless ref($inputs)  eq "ARRAY";
    croak "dumb targets" unless ref($targets) eq "ARRAY";

    $max_epochs = 4000 unless $max_epochs;
    $epsilon    =  0.0 unless $epsilon;

    print STDERR "me: $max_epochs, ep: $epsilon\n" if $debug;

    my @i = map(pack("d*", @$_), @$inputs);
    my @o = map(pack("d*", @$_), @$targets);

    while( --$max_epochs > 0 and $epsilon < $min_error ) {
        $this->reset_nmse;

        for my $i (0..$#i) {
            $this->set_input( $i[$i] );
            $this->train_on(  $o[$i] );
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

