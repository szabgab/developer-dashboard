#!/usr/bin/env perl
use Mojolicious::Lite -signatures;
#plugin 'AutoReload';
use Path::Tiny qw(path);
use Mojo::JSON qw(decode_json encode_json);
use Mojo::UserAgent;
use List::Util qw(sum0);
use Data::Dumper qw(Dumper);
use YAML qw(Load);

use lib 'lib';
use DDB::GitHub;

my $config = Load( path('config.yml')->slurp );
#app->secrets([$config->{mojo_secret}]);

get '/' => sub ($c) {
    $c->render(template => 'main', github_client_id => $config->{github_client_id});
};

get '/github' => sub ($c) {
    my $users = decode_json(path('data/users.json')->slurp_utf8);
    $c->render(template => 'users', users => $users);
};


get '/github/:name' => sub ($c) {
    my $name = $c->stash('name');

    my $users = decode_json(path('data/users.json')->slurp_utf8);
    my $repos = decode_json(path('data/repos.json')->slurp_utf8);
    my $open_issues = sum0 map {$_->{open_issues}} values %{ $repos->{$name} };
    $c->render(template => 'user',
        name => $name,
        user => $users->{$name},
        repos => $repos->{$name},
        open_issues => $open_issues,
    );
};

get '/cb/github' => sub ($c) {
    my $session_code = $c->param('code');
    $c->app->log->debug("session_code: $session_code");

    # TODO verify that the github_client_id and github_client_secret exist
    # TODO provide proper error message to the user if this step fails.
    my $ua  = Mojo::UserAgent->new();
    my $url = 'https://github.com/login/oauth/access_token';
    my %data = (
              client_id     => $config->{github_client_id},
              client_secret => $config->{github_client_secret},
              code          => $session_code,
    );
    my $res = $ua->post($url  => {Accept => 'application/json'} => json => \%data)->result;
    $c->app->log->debug($res->is_success);
    $c->app->log->debug($res->message);
    # { 'token_type' => 'bearer', 'scope' => 'user:email', 'access_token' => '123' };
    # TODO verify that we got a response, verify the scope
    $c->app->log->debug(Dumper $res->json);
    my $access_token = $res->json->{'access_token'};
    my $gh = DDB::GitHub->new($access_token);
    my $user = $gh->user;
    ## $gh->get_repos;
    $c->session(github => $user->{login});
    $c->redirect_to('/my');
};

group {
    my @systems = qw(github);
    under sub($c) {
        for my $system (@systems) {
            return 1 if $c->session($system);
        }
        $c->redirect_to('/');
        return undef;
    };
    get '/my' => sub ($c) {
        $c->render(template => 'my');
    };
    get '/my/logout' => sub ($c) {
        for my $system (@systems) {
            $c->session($system => undef);
        }
        $c->redirect_to('/');
    };
};

app->start;

