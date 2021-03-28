package DDB::GitHub;
use strict;
use warnings;
use 5.010;
use Net::GitHub ();
use Mojo::File qw(path);
use Mojo::Home ();
use Mojo::JSON qw(decode_json encode_json);

sub new {
    my ($class, $access_token) = @_;
    my $self = bless {}, $class;
    $self->{github} = Net::GitHub->new(
        version => 3,
        access_token => $access_token,
    );
    return $self;
}

sub get_user {
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

sub save_user {
    my ($self, $user) = @_;

    my $home = Mojo::Home->new;
    $home->detect;
    my $dir = $home->child('data', 'github', 'users');
    $dir->make_path;
    my $username = $user->{login};
    my $user_file = $dir->child("$username.json");
    $user_file->spurt(encode_json($user));
}

sub update_repos {
    my ($self, $username) = @_;

    my $repos = $self->get_repos;
    $self->save_repos($username, $repos);
}

sub save_repos {
    my ($self, $username, $repos) = @_;

    my $home = Mojo::Home->new;
    $home->detect;
    my $dir = $home->child('data', 'github', 'repos');
    $dir->make_path;
    my $repos_file = $dir->child("$username.json");
    $repos_file->spurt(encode_json($repos));
}

1;
