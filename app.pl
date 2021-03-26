#!/usr/bin/env perl
use Mojolicious::Lite -signatures;
#plugin 'AutoReload';
use Path::Tiny qw(path);
use Mojo::JSON qw(decode_json encode_json);


get '/' => sub ($c) {
    my $users = decode_json(path('data/users.json')->slurp_utf8);
    $c->render(template => 'users', users => $users);
};

get '/github/:name' => sub ($c) {
    my $name = $c->stash('name');

    my $users = decode_json(path('data/users.json')->slurp_utf8);
    my $repos = decode_json(path('data/repos.json')->slurp_utf8);
    $c->render(template => 'user', name => $name, user => $users->{$name}, repos => $repos->{$name});
};

app->start;

