# Authenticating Users
Learn how to manage access tokens to link your users accounts with Point Database.

> Warning: Please do not store your `apiKey` in your client application. This is meant to be used at a backend to backend communication.

## Creating an external user
```HTTP
POST https://dev.api.areyoupoint.com/users/${userId}
Host: dev.api.areyoupoint.com
Content-Type: application/json
Accept: */*
Authorization: Bearer ${apiKey}
```
> Important: Please ensure that your user ids are unique and do not include user personal information on them, such as email addresses for example.

### 200 Response
```JSON
{
  "user": {
    "id": "pointUserId",
    "email": null,
    "birthday": null,
    "height": null,
    "weight": null,
    "gender": null,
    "pronoun": null,
    "expectation": null,
    "firstName": null,
    "timezone": null
  }
}
```


## Getting an access token for a specific user
Generates an access token valid for a specific user
```HTTP
POST https://dev.api.areyoupoint.com/users/${userId}/access_token
Host: dev.api.areyoupoint.com
Content-Type: application/json
Accept: */*
Authorization: Bearer ${apiKey}
```
### 200 Response
```JSON
{
    "accessToken": {
        "token": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJwb2ludHwtb1BIbllUaEc2NFVGX0ZCMV8yNmwiLCJpYXQiOjE2NDUxMzc2MDcsImV4cCI6MTY0NTE0MTIwN30.8eIpFc01hpj0Mid325kvJlouQi8aLTBw93q3whwRtpM",
        "expiresIn": 86400
     }
}
```
The tokens have a default expiration time of 24 hours (86400 seconds)
>Important: We recommend creating an endpoint at your backend application to serve as a bridge between your client and this endpoint, so that the client can easily request for a new `access_token` whenever the current one expires.
![Get access token diagram.](get_token_diagram.png)


### Revoking a specific access token
Revokes a specific access token.
```HTTP
DELETE  https://dev.api.areyoupoint.com/users/${userId}/access_token/${accessToken}
Host: dev.api.areyoupoint.com
Content-Type: application/json
Accept: */*
Authorization: Bearer ${apiKey}
```
