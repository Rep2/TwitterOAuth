# TwitterOAuth

Simple, fully tested Twitter authorization header generator.

Usage:

```Swift
let authHeader = try generateOAuthAuthorizationHeader(url: url, method: method, queries: ["list_id" : id])
return ["Authorization" : authHeader]
```

or:

```Swift
try oauthSignature(consumerSecret: consumerSecret, authTokenSecret: tokenSecret, baseURL: url, method: method, parameters: parameters)
```
