#!/usr/bin/env perl
use strict;
use warnings;
use 5.010;

use Data::Dumper qw(Dumper);
use Mojo::UserAgent;


my $token_file = 'token.txt';
my $base_url = 'https://api.github.com';
my $token = read_token();

main();


sub main {
    #my $user = get_user('szabgab');
    say Dumper get_repos('szabgab');
    # homepage
    # size
    #           {
    #        'size' => 160,
    #        'homepage' => '',
    #        'owner' => {
    #                     'login' => 'szabgab',
    #                     'id' => 48833,
    #                     'type' => 'User',
    #                   },
    #        'forks' => 0,
    #        'open_issues' => 0,
    #        'has_issues' => $VAR1->[0]{'has_projects'},
    #        'pushed_at' => '2014-09-03T09:14:03Z',
    #        'archived' => $VAR1->[0]{'private'},
    #        'forks_count' => 0,
    #        'url' => 'https://api.github.com/repos/szabgab/Code-Explain',
    #        'watchers' => 2,
    #        'full_name' => 'szabgab/Code-Explain',
    #        'html_url' => 'https://github.com/szabgab/Code-Explain',
    #        'default_branch' => 'master',
    #        'git_url' => 'git://github.com/szabgab/Code-Explain.git',
    #        'updated_at' => '2014-09-03T09:14:03Z',
    #        'fork' => $VAR1->[0]{'private'},
    #        'created_at' => '2011-02-25T07:57:10Z',
    #        'description' => 'Explain some Perl code',
    #        'id' => 1410057,
    #        'license' => undef,
    #        'open_issues_count' => 0,
    #        'node_id' => 'MDEwOlJlcG9zaXRvcnkxNDEwMDU3',
    #        'stargazers_count' => 2,
    #        'name' => 'Code-Explain',
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




sub read_token {
    open my $fh, '<', $token_file or die;
    my $token = <$fh>;
    chomp $token;
    return $token;
}
