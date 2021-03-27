# Dashboard


## Development

Generate a [Personal Access token](https://github.com/settings/tokens) with "public_repo" enabled and save it in token.txt
along with your username:

e.g mine looks like this:

```
szabgab:119aa1a77f35f9456758793dkahfjahfkjahk1
```


Create a file called `config.yml` in the root of the project listing the github usernames you'd like to fetch.

```
github:
   - szabgab
   - arielszabo
```


Run the script to fetch data:

```
docker-compose exec fetch perl fetch.pl
```

```
docker-compose up --build
docker-compose run web bash
```

## Plans

* Fetch the list of repos and store some of the returned data
   - hompage
   - forks
   - open_issues
   - name  or full_name
   - language
* For each repo that has pushed_at more recent since our last update of that project

* [Get community profile metrics](https://docs.github.com/en/rest/reference/repos#get-community-profile-metrics)

* GET /repos/:owner/:repo/git/commits/:sha


login using GitHub on the response store the access token in the session and also store it in our "database" so we can use it even without the user being present.
Implement the session management so pages under the /my path are only accessible to logged in users. (implement all the repeated login, and logout mechanism).

When the user logs in for the first time using GitHub fetch the user information and also the list of repositories and store it in our database connecting this information with the access token.
Later the updating of the list of repositories should be handled by a separate job that runs without the web server.


## docs

* [GitHub API reference](https://docs.github.com/en/rest/reference)


## CSS

Generate CSS file (public/bulma.css) from SCSS file (sass/mystles.scss):

```
npm install
npm run css-build
```

