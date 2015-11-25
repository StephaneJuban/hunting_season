# hunting_season [![Build Status](https://secure.travis-ci.org/mikejarema/hunting_season.png)](http://travis-ci.org/mikejarema/hunting_season)

`hunting_season` is a ruby gem for interacting with the official [Product Hunt API](https://api.producthunt.com/v1/docs).


## Authentication

`hunting_season` can use any valid API token. Sources include:

1. A `Developer Token` generated in the [Product Hunt API Dashboard](http://www.producthunt.com/v1/oauth/applications).

2. A client OAuth token as generated by [oauth#token - Ask for client level token](https://api.producthunt.com/v1/docs/oauth_client_only_authentication/oauth_token_ask_for_client_level_token).

3. A user OAuth token as generated by [oauth#authorize - Ask for access grant code on behalf of the user](https://api.producthunt.com/v1/docs/oauth_user_authentication/oauth_authorize_ask_for_access_grant_code_on_behalf_of_the_user). See the [omniauth-producthunt gem](https://github.com/lukaszkorecki/omniauth-producthunt) for an Omniauth strategy that may work (I haven't tested it yet).

When you have a valid token, simply instantiate the `ProductHunt::Client` as follows:

```ruby
client = ProductHunt::Client.new('mytoken')
```


## Supported Endpoints

`hunting_season` is a work-in-progress, please [contribute](#contributing) if you need additional functionality.


### [posts#index - Get the posts of today](https://api.producthunt.com/v1/docs/posts/posts_index_get_the_posts_of_today)

Look up today's posts.

Post attributes are listed in the API docs and accessed like `post["name"]`, `post["id"]`, etc.

Example:
```ruby
client = ProductHunt::Client.new('mytoken')

posts = client.posts
posts.size       # -> 14
posts[0]["name"] # -> "Content Marketing Stack"
posts[0]["id"]   # -> 30425
```


### [posts#all - Get all the newest posts](https://api.producthunt.com/v1/docs/posts/posts_all_get_all_the_newest_posts)

Look up all posts.

Post attributes are listed in the API docs and accessed like `post["name"]`, `post["id"]`, etc.

Example:
```ruby
client = ProductHunt::Client.new('mytoken')

posts = client.all_posts(per_page: 1, order: 'asc')
posts[0]["name"] # -> "Ferro"
posts[0]["id"]   # -> 3
```


### [posts#show - Get details of a post](https://api.producthunt.com/v1/docs/posts/posts_show_get_details_of_a_post)

Look up a post using a required numeric ID.

Post attributes are listed in the API docs and accessed like `post["name"]`, `post["id"]`, etc.

Example:
```ruby
client = ProductHunt::Client.new('mytoken')

post = client.post(3372)
post["name"]
# => "namevine"
post["id"]
# => 3372
```


### [votes#index - See all votes for a post](https://api.producthunt.com/v1/docs/postvotes/votes_index_see_all_votes_for_a_post)

Look up a post's votes, with optional ordering and pagination.

Post attributes are listed in the API docs and accessed like `vote["user"]`, `vote["id"]`, etc.

Example, look up a post's votes and paginate through them in ascending order:
```ruby
client = ProductHunt::Client.new('mytoken')
post = client.post(3372)

votes = post.votes(per_page: 2, order: 'asc')
votes[0]["id"]
# => 46164
"#{votes[0]["user"]["name"]} #{votes[0]["user"]["headline"]}"
# => "Jack Smith  Co-Founded Vungle - Advisor to Coin"

votes_page_2 = post.votes(per_page: 2, order: 'asc', newer: votes.last["id"])
votes_page_2[0]["id"]
# => 46242
"#{votes_page_2[0]["user"]["name"]} #{votes_page_2[0]["user"]["headline"]}"
# => "Helen Crozier Keyboard Karma"
```


### [users#index - Get all users](https://api.producthunt.com/v1/docs/users/users_index_get_all_users)

Get all users using ordering and pagination as noted in the official API docs.

Example:
```ruby
client = ProductHunt::Client.new('mytoken')

users = client.users(order: 'asc')
users.first["name"] # -> "Nathan Bashaw"
users.first["headline"] # -> "Working on something new :)"
users.first["id"] # -> 1
```


### [users#show - Get details of a user](https://api.producthunt.com/v1/docs/users/users_show_get_details_of_a_user)

Look up a user by username or id.

User attributes are listed in the API docs and accessed like `user["name"]`, `user["headline"]`, etc.

Example:
```ruby
client = ProductHunt::Client.new('mytoken')
user = client.user('rrhoover')
user["name"]
# => "Ryan Hoover"
user["headline"]
# => "Product Hunt"
```


### [comments#index - Fetch all comments of a post](https://api.producthunt.com/v1/docs/comments/comments_index_fetch_all_comments_of_a_post)

Look up a post's comments, with optional ordering and pagination.

Example, look up a post's comments and paginate through them in ascending order:
```ruby
client = ProductHunt::Client.new('mytoken')
post = client.post(3372)

comments = post.comments(per_page: 2, order: 'asc')
comments[0]["id"]
# => 11378
"#{comments[0]["user"]["name"]}: #{comments[0]["body"]}"
# => "Andreas Klinger: fair point but not using thesaurus nor having the ..."

comments_page_2 = post.comments(per_page: 2, order: 'asc', newer: comments.last["id"])
comments_page_2[0]["id"]
# => 11558
"#{comments_page_2[0]["user"]["name"]}: #{comments_page_2[0]["body"]}"
# => "Mike Jarema: Namevine developer here -- feel free to ask any Qs about ..."
```


### [collections#index - Get newest collections](https://api.producthunt.com/v1/docs/collections/collections_index_get_newest_collections)

Look up all collections.

Collection attributes are listed in the API docs and accessed like `collection["name"]`, `collection["id"]`, etc.

Example:
```ruby
client = ProductHunt::Client.new('mytoken')

collections = client.collections
collections[0]["name"] # -> "Newest collection"
collections[0]["id"]   # -> 12345
```


### [collection#show - Get details of a collection](https://api.producthunt.com/v1/docs/collections/collection_show_get_details_of_a_collection)

Look up a collection using a required numeric ID.

Collection attributes are listed in the API docs and accessed like `collection["name"]`, `collection["id"]`, etc.

Example:
```ruby
client = ProductHunt::Client.new('mytoken')

collection = client.collection(1)
collection["name"]
# => "500 Startups: Demo Day"
collection["id"]
# => 1
```


### Accessing associated records

For some API responses, an ID reference to or partial details for an associated User or Post are supplied. `hunting_season` provides convenience methods to access the full details of these associated records.

Currently `#post` and `#user` apply when the associated record is present.

Example:
```ruby
comment = ProductHunt::Client.new('mytoken').post(3372).comments(order: 'asc').first

user_hash = comment["user"]   # this will access the partial user details embedded in the response to the #comments call above
user_hash.class
# => Hash
user_hash["name"]
# => "Andreas Klinger"

user_object = comment.user    # this will make a separate call to pull the full details of the user who commented
user_object.class
# => ProductHunt::User
user_object["name"]
# => "Andreas Klinger"

post_object = comment.post    # likewise for the associated post, this will pull full details of the post on which a comment was made via an additional API call
post_object.class
# => ProductHunt::Post
post_object["name"]
# => "namevine"
```


## ETAG Support

You can retrieve the etag for any call by calling `#etag` against the returned object or collection:

```ruby
client = ProductHunt::Client.new('mytoken')
post = client.post(3372)
etag = post.etag
```

You then can leverage [Product Hunt's API support](https://api.producthunt.com/v1/docs/example_performance_tips/use_the_e-tag_http_header) to increase performance by passing this etag on subsequent requests. If a record has NOT changed, it will respond to `#modified?` with false.

```ruby
post = client.post(3372, headers: { 'If-None-Match': etag }) # pass as custom header
post = client.post(3372, etag: etag)                         # OR explicitly

if post.modified?
  # do something with the modified post
else
  # the post remains unmodified, trying to access any attributes on this object will raise an exception
end
```

## Tests

There are two ways to run tests:

1. `bundle exec rake` which stubs out all of the calls to Product Hunt's API to local files.

2. `TOKEN=mytoken USE_LIVE_API=true bundle exec rake` which runs tests against live data from the Product Hunt API using your developer token.


## Contributing

Easy.

1. [Fork it](https://github.com/mikejarema/hunting_season/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Add new functionality, relevant tests and update the README if applicable
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create a new Pull Request


## Miscellany

Legal: see LICENSE

The name is inspired by a rapper buddy of mine: [Katchphraze - Huntin' Season](http://on.rdio.com/1zEb5cA) :headphones:

Copyright (c) 2014 Mike Jarema
