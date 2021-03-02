# Dashboard


## Development

Visit: https://github.com/settings/tokens
Generate a Personal Access token with "public_repo" enabled and save it in token.txt
along with your username:

e.g mine looks like this:

```
szabgab:119aa1a77f35f9456758793dkahfjahfkjahk1
```


## Plans

* A file with a list of GtHub usernames
* Fetch the list of repos and store some of the returned data
   - hompage
   - forks
   - open_issues
   - name  or full_name
   - language
   - pushed_at
    'default_branch' => 'master',
* For each repo that has pushed_at more recent since our last update of that project

* Are there pull-requests waiting for me?
* Are there open issues waiting for me?
* Which CI system do I have set up for the repository?
* [Get community profile metrics](https://docs.github.com/en/rest/reference/repos#get-community-profile-metrics)

* Get the default branch
* GET /repos/:owner/:repo/git/commits/:sha



## docs

* [GitHub API reference](https://docs.github.com/en/rest/reference)


```
docker-compose up --build
docker-compose run web bash
```

