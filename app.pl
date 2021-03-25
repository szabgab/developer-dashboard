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
   <a href="/github/<%= $user %>">
       <img class="avatar" src="<%= $users->{$user}{avatar_url} %>">
       <%= $users->{$user}{name} %>
   </a>
<% } %>

@@ user.html.ep

<a href="https://github.com/<%= $name %>">
    <img class="avatar" src="<%= $user->{avatar_url} %>">
    <%= $user->{name} %>
</a>

<% if ($user->{twitter_username}) { %>
    <a href="https://twitter.com/<%= $user->{twitter_username} %>">@<%= $user->{twitter_username} %></a>
<% } %>

<h2>Repositories</h2>

<table>
   <tr>
      <th>Repo</th>
      <th>Homepage</th>
      <th>Pushed AT</th>
   </tr>
<% for my $repo_name (sort keys %$repos) { %>
   <tr>
      <td><a href="https://github.com/<%= $name %>/<%= $repo_name %>"><%= $repo_name %></a></td>
      <td><%= $repos->{$repo_name}{homepage} %></td>
      <td><%= $repos->{$repo_name}{pushed_at} %></td>
   </tr>
<% } %>
</table>

