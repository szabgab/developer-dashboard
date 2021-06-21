use strict;
use warnings;
use 5.010;
use Data::Dumper qw(Dumper);

# This script is only used for experimenting with the GitHub API

#use lib 'lib';
#use DDB::GitHub;

my $access_token = shift or die "Usage: $0 ACCESS_TOKEN\n";
#my $gh = DDB::GitHub->new($token);
#print Dumper $gh->user;
#print Dumper $gh->get_repos;
#my %data = $self->{github}->query('/user');
#my @r = $self->{github}->repos->list({per_page => $SIZE, page => $page});
#print Dumper $gh->{github}->query('/issues'); # Not Found


use Net::GitHub;
my $gh = Net::GitHub->new(
    version => 3,
    access_token => $access_token,
);

my $user = 'szabgab';
my $repo_name = 'codeandtalk.com';

# Get issues for a specific repository
#$gh->set_default_user_repo($user, $repo_name);
#my @issues = $gh->issue->repos_issues;
#my @issues = $gh->issue->repos_issues($user, $repo_name, { state => 'open' } );
#print Dumper \@issues;

# Get pull requests for a specific repository
#my @prs = $gh->pull_request->pulls($user, $repo_name, { state => 'open' } );
#print Dumper \@prs;

# print Dumper $gh->query('/rate_limit');
