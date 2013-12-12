anonymouspost
=============

## TODO

- write the query to get nearby posts, ranked by relevance (votes, newness, distance)
- some sort of very basic frontend that hits the JSON api with JS and AJAX
- allow users to edit their posts

## Cool Ideas

- each user ID can have an optional public component, which is separated from the private part of the ID with a special character (`+` or something). The plaintext of the public component is not displayed. Instead, it is hashed and the hash is used to generate an abstract avatar (similar to the Github avatars) that is displayed with posts. This makes it impossible for a user to steal another's public tag, so users (or groups of users who share a public component between them) can sign their posts anonymously.