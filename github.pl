use strict;
use warnings;
use 5.010;
use Data::Dumper qw(Dumper);
use Net::GitHub;
#use Term::ReadPassword::Win32 qw(read_password);
#use Getopt::Long qw(GetOptions);

#my $username;
#GetOptions(
#    'username:s' => \$username,
#);
#my $access_token = shift or die "Usage: $0 ACCESS_TOKEN\n";

#my $password = read_password("Password: ");
my $gh = Net::GitHub->new(
    version => 3,
#    access_token => $access_token,
#    login => $username,
#    pass => $password,
);

my $user = 'fayland';
my $repo_name = 'perl-net-github';

# List pull-requests
#my @prs = $gh->pull_request->pulls($user, $repo_name, { state => 'open' } );
#print Dumper \@prs;

# Show rate-limit
# print Dumper $gh->query('/rate_limit');

# Get issues for a specific repository
# $gh->set_default_user_repo($user, $repo_name);
#my @issues = $gh->issue->repos_issues;

# ... or without setting default user and repo
#my @issues = $gh->issue->repos_issues($user, $repo_name, { state => 'open' } );
#print Dumper \@issues;

#my $res = $gh->query('/search/repositories', 'perl');
#my $res = $gh->query->repositories('perl');
my $res = $gh->repos->query('perl');
#,
#    per_page => 3,
#);
print Dumper $res;
