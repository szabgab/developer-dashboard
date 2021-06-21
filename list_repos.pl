use strict;
use warnings;
use Pithub::Repos;
use Data::Dumper qw(Dumper);

my $r = Pithub::Repos->new(
    per_page        => 100,
    auto_pagination => 1,
);
my $result = $r->list( user => 'szabgab' );

unless ( $result->success ) {
    printf "something is fishy: %s\n", $result->response->status_line;
    exit 1;
}

while ( my $row = $result->next ) {
    #printf "%s: %s\n", $row->{name}, $row->{description} || 'no description';
    print Dumper $row;
}
