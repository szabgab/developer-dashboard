#!/usr/bin/env perl
use Mojolicious::Lite -signatures;
#plugin 'AutoReload';
use Mojo::JSON qw(decode_json encode_json);
use Mojo::UserAgent;
use List::Util qw(sum0);
use Data::Dumper qw(Dumper);
use YAML qw(Load);
use Mojo::Home;
use Mojo::File qw(path);

use lib 'lib';
use DDB::GitHub;

my @systems = qw(github);

my $home = Mojo::Home->new;
$home->detect;
my $config = Load( $home->child('config.yml')->slurp );
#app->secrets([$config->{mojo_secret}]);

get '/' => sub ($c) {
    $c->render(template => 'main');
};

get '/github' => sub ($c) {
    my $users = decode_json(path('data/users.json')->slurp);
    $c->render(template => 'users', users => $users);
};


get '/github/:name' => sub ($c) {
    my $name = $c->stash('name');

    my $users = decode_json(path('data/users.json')->slurp);
    my $repos = decode_json(path('data/repos.json')->slurp);
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

    my $user = $gh->get_user;
    my $username = $user->{login};
    $user->{access_token} = $access_token;

    $gh->save_user($user);
    $gh->update_repos($username);

    $c->session(github => $username);
    $c->redirect_to('/my');
};

get '/my' => sub ($c) {
    my %data;
    my $logged_in = 0;
    for my $system (@systems) {
        my $username = $c->session($system);
        my $user_file = "data/$system/users/$username.json";
        if (-e $user_file) {
            $data{$system} = decode_json(path($user_file)->slurp);
            $logged_in = 1;
        }

    }
    $c->render(template => 'my',
        user => \%data,
        github_client_id => $config->{github_client_id},
        logged_in => $logged_in,
    );
};

group {
    under sub($c) {
        for my $system (@systems) {
            return 1 if $c->session($system);
        }
        $c->redirect_to('/');
        return undef;
    };
    get '/my/github' => sub ($c) {
        my $username = $c->session('github');

        my $home = Mojo::Home->new;
        $home->detect;
        my $user_file = $home->child('data', 'github', 'users', "$username.json");
        my $user = decode_json($user_file->slurp);

        my $repos_file = $home->child('data', 'github', 'repos', "$username.json");
        my $repos = decode_json($repos_file->slurp);
        my $open_issues = sum0 map {$_->{open_issues}} @$repos;
        $c->render(template => 'github',
            name => $username,
            user => $user,
            repos => $repos,
            open_issues => $open_issues,
        );
    };


    # TODO logout from one specific service
    get '/my/logout' => sub ($c) {
        for my $system (@systems) {
            $c->session($system => undef);
        }
        $c->redirect_to('/');
    };
};

app->start;

