package AI::jNeural::nets::kohonen;

require 5.005_62;
use strict;
use warnings;
use Carp;

require Exporter;
require DynaLoader;
use AutoLoader;

our @ISA         = qw(Exporter DynaLoader);
our %EXPORT_TAGS = ( 'all' => [ qw( ) ] );
our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );
our @EXPORT = qw( );
our $VERSION = '0.02';

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
	    croak "Your vendor has not defined AI::jNeural::nets::kohonen macro $constname";
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

bootstrap AI::jNeural::nets::kohonen $VERSION;

return 1;

sub set_input {
    my $self = shift;

    my $cArray= pack( "d*", @_ );

    $self->_set_input( $cArray );
}

sub update_learning_rate {
    my $self  = shift;
    my $gamma = shift;

    return $self->_update_learning_rate_g($gamma) if $gamma;
    return $self->_update_learning_rate;
}

__END__

=head1 NAME

AI::jNeural::nets::kohonen - Kohonen nets via libjneural

=head1 SYNOPSIS

   use AI::jNeural::nets::kohonen; $loaded = 1;

  $radius  = 0;
  $epsilon = 0.00001;

  @matrix  = (
      [1, 1, 0, 0],
      [1, 0, 0, 0],
      [0, 0, 0, 1],
      [0, 0, 1, 1],
  );

  $the_net = new AI::jNeural::nets::kohonen(0.9, 4, 2);
  {
      foreach $row ( @matrix ) {
          set_input     $the_net @$row;
          linear_train  $the_net $radius;
      }
      redo if update_learning_rate $the_net > $epsilon;
  }

  foreach $row ( @matrix ) {
      $the_net->set_input(@$row); 

      $max = $the_net->query_max_output;

      print "[" . (join ", ", @$row) . "] was put in group $max.\n";
  }

=head1 AUTHOR

Jettero Heller <jettero@voltar.org>

Jet's Neural Architecture is a C++ library.
<http://www.voltar.org/jneural>

=head1 SEE ALSO

perl(1), AI::jNeural(3), AI::jNeural::arch::neuron(3), AI::jNeural::arch(3), AI::jNeural::nets::kohonen(3), AI::jNeural::nets(3), AI::jNeural::utils::transfer(3), AI::jNeural::utils(3).

=cut
