package AI::jNeural::utils::transfer;

require 5.005_62;
use strict;
use warnings;
use Carp;

require Exporter;
require DynaLoader;
use AutoLoader;

our @ISA = qw(Exporter DynaLoader);
our %EXPORT_TAGS = ( 'types' => [ qw( BIPOLAR ELLIOTT JBIPOLR SIGMOID SUM ) ] );
our @EXPORT_OK   = ( @{ $EXPORT_TAGS{'types'} } );
our @EXPORT      = qw();
our $VERSION     = '0.52';

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
	    croak "Your vendor has not defined AI::jNeural::utils::transfer macro $constname";
	}
    }
    {
	no strict 'refs';
	# Fixed between 5.005_53 and 5.005_61
	#if ($] >= 5.00561) {
	#    *$AUTOLOAD = sub () { $val };
	#}
	#else {
	    *$AUTOLOAD = sub { $val };
	#}
    }
    goto &$AUTOLOAD;
}

bootstrap AI::jNeural::utils::transfer $VERSION;

return 1;

__END__

=head1 NAME

AI::jNeural::utils::transfer - Perl extension neural transfer functions

=head1 SYNOPSIS

  use AI::jNeural::utils::transfer qw/:types/;
  # This is all you'll ever need to do with this module...
  # For fits and shiggles, I inlcuded the xfer and xfer_dot
  # functions.

  print "xfer(0.5, SIGMOID) = ", 
    AI::jNeural::utils::transfer::xfer(0.5, SIGMOID), 
    "\n";

=head1 Exportable constants

=head2 :funcs
  SUM     - a simple sum
  SIGMOID - a standard sigmoid
  BIPOLAR - a standard bipolar
  JBIPOLR - Jet's bipolar
  ELLIOTT - An Elliott function

=head1 AUTHOR

Jettero Heller <jettero@voltar.org>

Jet's Neural Architecture is a C++ library.
<http://www.voltar.org/jneural>

=head1 SEE ALSO

perl(1), AI::jNeural(3), AI::jNeural::arch::neuron(3), AI::jNeural::arch(3), AI::jNeural::nets::backprop(3), AI::jNeural::nets(3), AI::jNeural::nets::kohonen(3), AI::jNeural::utils::transfer(3), AI::jNeural::utils(3).

=cut
