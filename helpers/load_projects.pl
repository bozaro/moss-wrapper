#! /usr/bin/perl -w

use strict;
use warnings;
use utf8;

my %urls = (
    'https://github.com/TimeEscaper/tp_databases_autumn_2016' => 'java',
);

for my $url (keys %urls) {
    my $dir = $urls{$url};
    my $res =  `cd $dir && git clone $url`;
    warn $res if $res;
}
