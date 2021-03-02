#!/usr/bin/env perl
use Mojolicious::Lite -signatures;
#plugin 'AutoReload';
use Path::Tiny qw(path);
use Mojo::JSON qw(decode_json encode_json);


get '/' => sub ($c) {
    my $users = decode_json(path('data/users.json')->slurp_utf8);
    $c->render(template => 'users', users => $users);
};

app->start;
__DATA__

@@ users.html.ep
<style>
.avatar {
   width: 80px;
}
</style>
<h1>Users</h1>
<% for my $user (sort keys %{ $users }) { %>
   <hr>
   <a href="https://github.com/<%= $user %>">
       <img class="avatar" src="<%= $users->{$user}{avatar_url} %>">
       <%= $users->{$user}{name} %>
   </a>
<% } %>

