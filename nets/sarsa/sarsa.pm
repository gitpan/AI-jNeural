package AI::jNeural::nets::sarsa;
# $Id: sarsa.pm,v 1.3 2002/12/10 16:22:48 jettero Exp $
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
our $VERSION = '0.08';

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
            croak "Your vendor has not defined AI::jNeural::nets::sarsa macro $constname";
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

bootstrap AI::jNeural::nets::sarsa $VERSION;
# }}}

return 1;

sub set_state {
    my ($this, $state) = @_;

    $this->_set_state( pack("d*", @$state) );
}

__END__

=head1 NAME

    AI::jNeural::nets::sarsa - SARSA nets via libjneural

    State action reward state action 

    TD(lambda)

=head1 Synopsis

    This documentation blows.  This module is about half done, so relax. ;)
    Email feature requests, interface questions, angry emotive expressions, and 
    all other commetns to the author.

    Warning:  The interface can (and will) change at any time.  It will never do
    less than it does now, but the calls may change drastically over time.  Deal
    with it. ;)

=head1 AUTHOR

Jettero Heller <jettero@voltar.org>

Jet's Neural Architecture is a C++ library.
<http://www.voltar.org/jneural>

=head1 SEE ALSO

perl(1), AI::jNeural(3), AI::jNeural::arch::neuron(3), AI::jNeural::arch(3), AI::jNeural::nets::backprop(3), AI::jNeural::nets(3), AI::jNeural::nets::kohonen(3), AI::jNeural::nets::sarsa(3), AI::jNeural::utils::transfer(3), AI::jNeural::utils(3).

=cut
