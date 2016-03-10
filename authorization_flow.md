# Authentication and Authorization

- This is built using JWT (JSON Web Token).
- Use a different base URL to access the endpoints: https://auth.neon-lab.com
- Endpoints are accessible *only* via HTTPS.

## Call Flow

A username and password will be supplied to you when your customer account is created.

Use these to call:

    POST https://auth.neon-lab.com/api/v2/authenticate

    {
        "username": "yourusername",
        "password": "yourpass"
    }

An `access_token`, `refresh_token` pair is passed back on success

    {
        "access_token": "access_token",
        "refresh_token": "refresh_token"
    }

The `access_token` is a short-lived token (12 minutes), and can be used to make
calls to any of the API endpoints in this document.

The `refresh_token` is a longer-lived token which can be used to refresh the
`access_token`.

Passing the `access_token` to the API can be done in three different ways:

1. As the query_string parameter:

    /a123/integrations/brightcove?integration_id=15add06a5cc511e5b7da00904c0df43e&token=access_token

2. In the JSON-encoded body parameters:

    /api/v2/pvmprjg44t5x7cqcrsw0i6tn/integrations/brightcove

    {
        "publisher_id": "123badf",
        "token": "access_token"
    }

3. As an `Authorization: Bearer` header:

    HEADER :

    Authorization: Bearer access_token
    /a123/integrations/brightcove?integration_id=15add06a5cc511e5b7da00904c0df43e
