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
    for my $username (@{ $config->{users} }) {
        say $username;
        my $user = get_user($username);
        store_user($username, $user);

        my $repos = get_repos($username);
        #die Dumper $repos;
        store_repos($username, $repos)
    }
    #           {
    #        'size' => 160,
    #        'homepage' => '',
    #        'forks' => 0,
    #        'open_issues' => 0,
    #        'has_issues' => $VAR1->[0]{'has_projects'},
    #        'forks_count' => 0,
    #        'watchers' => 2,
    #        'updated_at' => '2014-09-03T09:14:03Z',
    #        'fork' => $VAR1->[0]{'private'},
    #        'created_at' => '2011-02-25T07:57:10Z',
    #        'description' => 'Explain some Perl code',
    #        'id' => 1410057,
    #        'license' => undef,
    #        'open_issues_count' => 0,
    #        'node_id' => 'MDEwOlJlcG9zaXRvcnkxNDEwMDU3',
    #        'stargazers_count' => 2,
    #        'watchers_count' => 2,
    #        'has_pages' => $VAR1->[0]{'private'},
    #        'language' => 'Perl',
    #      },
}

sub get_repos {
    my ($username) = @_;
    _get("/users/$username/repos")
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

    my %this;
    my @repo_fields = ('name', 'homepage', 'size', 'default_branch', 'pushed_at');
    for my $repo (@$repos) {
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
