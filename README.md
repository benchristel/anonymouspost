anonymouspost
=============

## TODO

- allow users to vote on posts
- allow users to delete their posts
- view for a single post, showing detailed location info and the full text
- mobile css
- prettier css
- account creation and sign in as two separate functions
- rate limit requests (if it's easy in Rails)
- ban the null user
- voting arrows should be highlighted to show your existing vote
- display distance from user instead of GPS coords
- display human-readable time format

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
- UI for adjusting max distance of posts to display
- each user ID can have an optional public component, which is separated from the private part of the ID with a special character (`+` or something). The plaintext of the public component is not displayed. Instead, it is hashed and the hash is used to generate an abstract avatar (similar to the Github avatars) that is displayed with posts. This makes it impossible for a user to steal another's public tag, so users (or groups of users who share a public component between them) can sign their posts anonymously.

## Contributing

1. Fork this repo and make your changes.
2. Run the tests with `bundle exec rspec spec` to make sure nothing's broken.
3. Submit a pull request.
4. Wait 1000 years.
