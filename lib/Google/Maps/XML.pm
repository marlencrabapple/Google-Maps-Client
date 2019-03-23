package Google::Maps::XML;

use strict;
use warnings;

use v5.28;

use XML::LibXML;
use Carp qw(croak);

sub unserialize {
  my $dom = XML::LibXML->load_xml( string => $_[0] );
  croak "Could not decode XML." unless $dom;

  return $dom
}

1