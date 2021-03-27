use strict;
use warnings;
use 5.010;
use Data::Dumper qw(Dumper);

# This script is only used for experimenting with the GitHub API

use lib 'lib';
use DDB::GitHub;

my $token = shift or die "Usage: $0 ACCESS_TOKEN\n";
my $gh = DDB::GitHub->new($token);
print Dumper $gh->user;
print Dumper $gh->get_repos;

