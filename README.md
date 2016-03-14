# Neon Labs API Documentation

This is the documentation for Neon Labs' API. It's implemented in JSON in an
extended variant of [Swagger].

## Multiple documentation sets

We'd like both public and internal sets of documentation, and we'd like to be
able to generate them both from the same template.

We've extended the Swagger "language" to include the notion of documentation
sets. Each documentation set represents a target that we want to build.

At the top level we define an array of `documentationSets`:

    "documentationSets": [
      "public",
      "internal"
    ]

Each endpoint (or "path") has an `onlyVisibleInDocumentationSets` key that
defines which documentation that endpoint appears in. So for an internal
endpoint that shouldn't be public, we'd add:

    "onlyVisibleInDocumentationSets": [
      "internal"
    ]

Each endpoint defaults to being visible in all documentation sets.

Parsing this template and generating the appropriate documentation sets is
implemented as a Ruby script and can be run through a Makefile. The Makefile
also include a `validate` task, which runs `swagger validate` on the generated
documentation to ensure that it's well-formed.

## Building the docs

Generating the documentation requires GNU Make and Ruby (>= 1.8). You'll also
need `swagger` if you'd like to validate the generated docs:

    $ npm install swagger

Generating:

    $ make

Validating:

    $ make validate

Validating will also build the docs, so `make validate` is enough if you want to
do both at once.

You can also delete the generated documentation with `make clean`.

## Workflow for making changes

To make a change in the documentation:

1. Edit the JSON template.
2. Run `make validate`. Tweak your modifications until the generated Swagger
   documentation is valid.
3. Check the generated documentation to make sure they look the way you'd like.
   Make sure that private stuff isn't inadvertently included in the public
   documentation set.
4. Copy the generated documentation sets to wherever they need to go (probably
   the [public] and [internal] documentation repositories).

[Swagger]: http://swagger.io/
[public]: https://github.com/neon-lab/api-docs-public
[internal]: https://github.com/neon-lab/api-docs-private
