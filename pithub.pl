use strict;
use warnings;
use 5.010;

use Pithub;
use Data::Dumper;

my $p = Pithub->new;
#print $p->repos; # PitHub::Repos
my $result = $p->repos->get( user => 'plu', repo => 'Pithub' );
#print $result; # Pithub::Result=HASH(0x55c065971450)

#say $result->response; # https://metacpan.org/pod/HTTP::Response
#say $result->response->is_success; # True or false
$result->

