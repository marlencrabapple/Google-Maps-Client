package Google::Maps::Client;

use v5.28;

use strict;
use warnings;

use HTTP::Tiny;
use HTTP::Tinyish; # Enables verify_SSL option work on more platforms
use Carp qw(croak);
use Encode qw(decode);
use List::Util qw(any);

our $VERSION = '0.01';

our $ua = HTTP::Tinyish->new( verify_SSL => 1 );

sub new {
  my ($class, %args) = @_;
  
  croak 'No API key.' unless $args{api_key};

  $args{output_format} = 'json' unless $args{output_format};

  if($args{decoder}) {
    croak "Response decoder must be a code ref" unless ref $args{decoder} eq 'CODE';
  }
  else {
    if($args{output_format} eq 'json') {
      $args{decoder_class} = 'Google::Maps::JSON'
    }
    elsif($args{output_format} eq 'xml') {
      $args{decoder_class} = 'Google::Maps::XML'
    }
    else {
      croak "Invalid output format '$args{output_format}'."
    }

    $args{decoder_path} = $args{decoder_class};
    $args{decoder_path} =~ s/::/\//g;
    require "$args{decoder_path}.pm";

    $args{decoder} = sub {
      no strict 'refs';
      "$args{decoder_class}::unserialize"->(@_);
      use strict
    };
  }

  $args{base_uri} = "https://maps.googleapis.com/maps/api/geocode/$args{output_format}";

  bless \%args, $class
}

sub geocode {
  my ($self, $data) = @_;
  croak 'Missing address or components.' unless any { $_ } qw(address components);
  return $self->_get($data)
}

sub reverse_geocode {

}

sub _validate_args {

}

sub _get {
  my ($self, $data, $options) = @_;

  $$data{key} //= $$self{api_key};

  my $res = $ua->get("$$self{base_uri}?" . HTTP::Tiny->www_form_urlencode($data));

  if($$res{success}) {
    return $$self{decoder}->(decode('utf-8', $$res{content}))
  }
  else {
    croak "$$res{status} - $$res{reason}:\n\n$$res{content}";
  }
}

1

__END__

=encoding utf-8

=head1 NAME

Google::Maps::Client - Blah blah blah

=head1 SYNOPSIS

  use Google::Maps::Client;

=head1 DESCRIPTION

Google::Maps::Client is

=head1 AUTHOR

Ian P Bradley E<lt>ian.bradley@studiocrabapple.comE<gt>

=head1 COPYRIGHT

Copyright 2019- Ian P Bradley

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut
