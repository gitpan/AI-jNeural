package AI::jNeural;

require 5.005_62;
use strict;
use warnings;

require Exporter;
use AutoLoader qw(AUTOLOAD);

our @ISA = qw(Exporter);

our %EXPORT_TAGS = ( 'all' => [ qw( ) ] );
our @EXPORT_OK   = ( @{ $EXPORT_TAGS{'all'} } );
our @EXPORT      = qw( );
our $VERSION     = '0.48';

return 1;

__END__

=head1 NAME

AI::jNeural::arch - The Jet's Neural Architecture base module

=head1 SYNOPSIS

  use AI::jNeural;

=head1 DESCRIPTION

This particular module doesn't actually do anything.  It would be the place to
look for functions that are general to the entire library, but there really
arn't any yet.

=head1 AUTHOR

Jettero Heller <jettero@voltar.org>

Jet's Neural Architecture is a C++ library.
<http://www.voltar.org/jneural>

=head1 SEE ALSO

perl(1), AI::jNeural(3), AI::jNeural::arch::neuron(3), AI::jNeural::arch(3), AI::jNeural::nets::backprop(3), AI::jNeural::nets(3), AI::jNeural::nets::kohonen(3), AI::jNeural::utils::transfer(3), AI::jNeural::utils(3).

=cut
