package DDB::GitHub;
use strict;
use warnings;
use 5.010;
use Net::GitHub;

sub new {
    my ($class, $access_token) = @_;
    my $self = bless {}, $class;
    $self->{github} = Net::GitHub->new(
        version => 3,
        access_token => $access_token,
    );
    return $self;
}

sub user {
    my ($self) = @_;
    my %data = $self->{github}->query('/user');
    return \%data;
}

sub get_repos {
    my ($self) = @_;

    my $SIZE = 100; # this can be max 100
    my @repos;
    my $page = 1;
    while (1) {
        my @r = $self->{github}->repos->list({per_page => $SIZE, page => $page});
        push @repos, @r;
        $page++;
        last if scalar(@r) < $SIZE;
    }
    return \@repos;
}

1;
