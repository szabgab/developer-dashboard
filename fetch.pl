#!/usr/bin/env perl
use strict;
use warnings;
use 5.010;

use Data::Dumper qw(Dumper);
use Mojo::UserAgent;
use Mojo::JSON qw(decode_json encode_json);
use Path::Tiny qw(path);
use YAML qw(Load);


my $token_file = 'token.txt';
my $base_url = 'https://api.github.com';
my $token = read_token();

main();


sub main {
    my $config = Load( path('config.yml')->slurp );
    #die Dumper $config;
    for my $username (@{ $config->{github} }) {
        say $username;
        my $user = get_user($username);
        store_user($username, $user);

        my $repos = get_repos($username, $user->{public_repos});
        #die Dumper $repos;
        store_repos($username, $repos)
    }
}

sub get_repos {
    my ($username, $public_repos) = @_;
    # https://docs.github.com/en/rest/reference/repos#list-repositories-for-a-user
    # We can only fetch the repos 100 max, so we need to ask for them several times.
    my $per_page = 100;  # max
    my @repos;
    for my $page (1 .. 1 + int(($public_repos-1) / $per_page)) {
        say $page;
        my $ref = _get("/users/$username/repos?per_page=$per_page&page=$page");
        push @repos, @$ref;
    }
    return \@repos;
}

sub get_user {
    my ($username) = @_;
    _get("/users/$username");
}

sub _get {
    my ($path) = @_;
    my $url  = Mojo::URL->new("$base_url$path")->userinfo($token);;
    my $ua  = Mojo::UserAgent->new($url);
    my $res = $ua->get($url)->result;
    #say $res->is_success;
    #say $res->code;
    return $res->json;
}

sub store_repos {
    my ($username, $repos) = @_;

    path('data')->mkpath;

    my $filename = 'data/repos.json';
    my $data = {};
    if (-e $filename) {
        $data = decode_json( path($filename)->slurp_utf8 );
    }
    $data->{$username} = {};

    my @repo_fields = ('name', 'homepage', 'size', 'default_branch', 'pushed_at',
        'fork', 'description', 'forks', 'open_issues', 'has_issues',
        'forks_count', 'license', 'open_issues_count', 'has_pages', 'language');
    for my $repo (@$repos) {
        my %this;
        for my $field (@repo_fields) {
            $this{$field} = $repo->{$field};
        }
        $data->{$username}{ $this{name} } = \%this;
    }

    path($filename)->spew_utf8(encode_json($data));
}

sub store_user {
    my ($username, $user) = @_;
    #say Dumper $user;
    path('data')->mkpath;
    my $users_file = 'data/users.json';
    my $data = {};
    if (-e $users_file) {
        $data = decode_json( path($users_file)->slurp_utf8 );
    }
    my %this;
    my @user_fields = ('public_repos', 'avatar_url', 'twitter_username', 'name', 'type', 'email');
    for my $field (@user_fields) {
        $this{$field} = $user->{$field};
    }
    $data->{$username} = \%this;

    path($users_file)->spew_utf8(encode_json($data));
}



sub read_token {
    open my $fh, '<', $token_file or die;
    my $token = <$fh>;
    chomp $token;
    return $token;
}
