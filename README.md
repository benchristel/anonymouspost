anonymouspost
=============

## TODO

- Posts API should inform clients of whether they've voted on a post, and in which direction
- After signin, reload the posts to get data on editability and votes
- client should update after getting response from POSTs and PUTs if clientside prediction is wrong
- account creation and sign in as two separate functions
- allow users to delete their posts
- view for a single post, showing detailed location info and the full text
- mobile css
- rate limit requests (if it's easy in Rails)
- ban the null user
- voting arrows should be highlighted to show your existing vote
- display distance from user instead of GPS coords
- display human-readable time format
- rate-limit signups from a given IP
- limit posts index view to ~50 posts on initial load, and let the user load more if desired
- poll for new posts, Twitter-style

## Cool Ideas

- CAPTCHAs
- spam filtering
  - asynchronous spam detection, via a Resque worker (similar to a Cron job) that processes new posts
  - Naive Bayes on words and trigrams (sequences of 3 consecutive characters). This will allow us to filter out spam based on both words and letter sequences (e.g. `asdf` is probably spam). It will also allow NB to distinguish between "fyh ueiq lxckw poqwls nnw.com" and "Por que este sitio no me deja poner en español" without necessarily having non-English dictionaries.
- hide downvoted posts in the client (with an option to reshow the post)
- tags
- search
- hyperlink parsing!!!!!!
- Editing posts
- comments (also with up and down votes)
- UI for adjusting max distance of posts to display
- each user ID can have an optional public component, which is separated from the private part of the ID with a special character (`+` or something). The plaintext of the public component is not displayed. Instead, it is hashed and the hash is used to generate an abstract avatar (similar to the Github avatars) that is displayed with posts. This makes it impossible for a user to steal another's public tag, so users (or groups of users who share a public component between them) can sign their posts anonymously.

## Contributing

1. Fork this repo and make your changes.
2. Use the following rhyming incantation to make sure nothing's broken:

   ```
   bundle exec rspec spec
   ```
   
   If you don't do this before pull-requesting your change, we'll laugh, cry, cry tears of blood, fire will rain into the sea, and the Goat of Manifold Brood will devour the earth entire.

3. Submit a pull request.
4. Wait 1000 years.
