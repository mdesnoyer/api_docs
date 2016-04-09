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

An `access_token`, `refresh_token`, `account_ids` triple is passed back on success

    {
        "access_token": "access_token",
        "refresh_token": "refresh_token",
        "account_ids" : "list of NeonUserAccounts this User is associated with" 
    }

The `access_token` is a short-lived token (12 minutes), and can be used to make
calls to any of the API endpoints in this document.

The `refresh_token` is a longer-lived token which can be used to refresh the
`access_token`.

The `account_ids` will show which Accounts this User can make calls against. This
can be used at login to allow a User to choose, which account they want to use for 
the session. 

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

## Refresh Token Flow 

The `refresh_token` is a longer-lived (14 days) token, which can be used to refresh the 
shorter-lived `access_token`. This token should only ever be passed to the *https* endpoints 
on auth. Treat this token as you would with a password, and do not share it with anyone. 

The refresh_token endpoint should be called when a *http_code* of 401 is returned, along with 
a message of --access token is expired, please refresh the token--. 

Calling the endpoint, this can again be done in the three ways mentioned in the other flow. This 
will just show the body parameters method: 

1. In the JSON-encoded body parameters:

    POST https://auth.neon-lab.com/api/v2/refresh_token
    { 
        "token": "refresh_token" 
    } 

An `access_token`, `refresh_token`, `account_ids` triple is passed back on success

    {
        "access_token": "access_token",
        "refresh_token": "refresh_token",
        "account_ids" : "list of NeonUserAccounts this User is associated with" 
    }

The `access_token` is now refreshed, and you can begin making calls to the APIs again. 

If you receive a *http_code* of 401, along with a message of --refresh token has expired, please authenticate again--
Simply call authenticate again with username and a password. This will refresh both the access and refresh token, 
and give your refresh token another 14 days of use.

## Logging Out 

If you need to kill a session, there is a logout endpoint as well. This endpoint takes in an `access_token` and 
will clear the `access_token` and `refresh_token` for the User that is associated with the `access_token`. 

To call : 
 
1. In the JSON-encoded body parameters:

    POST https://auth.neon-lab.com/api/v2/logout
    { 
        "message": "successfully logged out user" 
    } 

In order to start using the API again, you must call authenticate with username and password. 
