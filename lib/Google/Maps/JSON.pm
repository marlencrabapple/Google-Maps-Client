package Google::Maps::JSON;

use strict;
use warnings;

use v5.28;

use JSON::MaybeXS;

sub unserialize {
  decode_json($_[0]);
}

1