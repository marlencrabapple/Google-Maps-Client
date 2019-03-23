requires 'perl', '5.28.1';

requires 'Carp';
requires 'Encode';
requires 'List::Util';
requires 'HTTP::Tiny';
requires 'HTTP::Tinyish';

on test => sub {
    requires 'Test::More', '0.96';
}