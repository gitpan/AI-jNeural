package AI::jNeural::arch::neuron;

require 5.005_62;
use strict;
use warnings;
use Carp;

require Exporter;
require DynaLoader;
use AutoLoader;

our @ISA         = qw(Exporter DynaLoader);
our %EXPORT_TAGS = ( 'all' => [ qw() ] );
our @EXPORT_OK   = ( @{ $EXPORT_TAGS{'all'} } );
our @EXPORT      = qw();
our $VERSION     = '0.01';

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
	}
	else {
	    croak "Your vendor has not defined AI::jNeural::arch::neuron macro $constname";
	}
    }
    {
	no strict 'refs';
	# Fixed between 5.005_53 and 5.005_61
	if ($] >= 5.00561) {
	    *$AUTOLOAD = sub () { $val };
	}
	else {
	    *$AUTOLOAD = sub { $val };
	}
    }
    goto &$AUTOLOAD;
}

bootstrap AI::jNeural::arch::neuron $VERSION;

return 1;

__END__

=head1 NAME

AI::jNeural::arch::neuron - The most basic unit of a neural net.

=head1 SYNOPSIS

  use AI::jNeural::arch::neuron;

  my @neurons;

  push @neurons, 
      new AI::jNeural::arch::neuron("Neuron #$_")
          for(1..10);

  print "name: , $neurons[$_]->query_name, "\n" for(0..$#neurons);

=head1 AUTHOR

Jettero Heller <jettero@voltar.org>

Jet's Neural Architecture is a C++ library.
<http://www.voltar.org/jneural>

=head1 SEE ALSO

perl(1), AI::jNeural(3), AI::jNeural::arch::neuron(3), AI::jNeural::arch(3), AI::jNeural::nets::backprop(3), AI::jNeural::nets(3), AI::jNeural::nets::kohonen(3), AI::jNeural::nets::sarsa(3), AI::jNeural::utils::transfer(3), AI::jNeural::utils(3).

=cut
