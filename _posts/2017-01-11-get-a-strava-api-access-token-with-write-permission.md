---
layout: post
title: 'Get a Strava API access token with write permission'
description: 'How to get a Strava API access token with write permission quickly without coding up an actual OAuth2 authorization flow.'
categories: [tutorials]
tags: [api, strava]
redirect_from:
  - /2017/01/11/
---

> Recently Updated - February 16, 2019. Updated as Strava API has new authentication scopes.

While Strava Developer Challenge 2016 was under way last September,
I spent quite some time playing around with Strava API V3.

In order to access the API, the first step is to get an access token.
The [API application settings][api application settings] page provides a public access token to get started.

However, Strava has defined seven different types of permissions to access the API:

- **`read`**
- **`read_all`**
- **`profile:read_all`**
- **`profile:write`**
- **`activity:read`**
- **`activity:read_all`**
- **`activity:write`**

Please refer to the [official documentation](https://developers.strava.com/docs/authentication/#details-about-requesting-access)
for what each scope represent.

The access token retrieved via `Settings` -> `My API Application` has the default permission,
which means it can only read public profile.
But I was writing some simple scripts to delete and upload new activities,
which requires an access token with write permission.
So how to quickly get a Strava access token with write access
without code up a web application with OAuth2 authorization flow?

After some investigation, here are the steps as below.

## Get authorization code

1.  Create a request URL for Strava authorization,
    where the base URL is `https://www.strava.com/oauth/authorize`
    and parameters are:

     <div class="data-table">
     <table border="1">
         <tr>
             <td>client_id</td>
             <td>your application’s ID, obtained during registration</td>
         </tr>
         <tr>
             <td>redirect_uri</td>
             <td>URL to which the user will be redirected with the authorization code.
             <br />A random but unique one on localhost should be fine.</td>
         </tr>
         <tr>
             <td>response_type</td>
             <td>must be 'code'</td>
         </tr>
         <tr>
             <td>scope</td>
             <td>'read', 'read_all', 'profile:read_all', 'profile:write', 'profile:write', 'activity:read', 'activity:read_all', 'activity:write'</td>
         </tr>
     </table>
     </div>

        http://www.strava.com/oauth/authorize?client_id=[REPLACE_WITH_YOUR_CLIENT_ID]&response_type=code&redirect_uri=http://localhost/exchange_token&approval_prompt=force&scope=profile:write,activity:write

2.  Go to above URL in browser. (HTTP GET)
3.  Login to Strava then click 'Authorize' and tick the required permissions if needed.
4.  Browser should go to 404 as `http://localhost/exchange_token` doesn't exist.
5.  Copy the authorization code from URL. For example,

         http://localhost/exchange_token?state=&code=c498932e64136c8991a3fb31e3d1dfdf2f859357&scope=read,profile:write,activity:write

    The authorization code for next step is `c498932e64136c8991a3fb31e3d1dfdf2f859357`.

    <a class="post-image" href="/assets/images/posts/2017-01-11-get-strava-authorization-code.gif">
    <img itemprop="image" data-src="/assets/images/posts/2017-01-11-get-strava-authorization-code.gif" src="/assets/javascripts/unveil/loader.gif" alt="Get authorization code from Strava" />
    </a>

## Exchange Token

Use any HTTP Rest Client to perform POST to `https://www.strava.com/oauth/token`
as defined in documentation [here][strava-api-token].

- **`client_id`**: your application’s ID, obtained during registration<br />
- **`client_secret`**: your application’s secret, obtained during registration<br />
- **`code`**: authorization code from last step
- **`grant_type`**: the grant type for the request. For initial authentication, must always be "authorization_code".

      $ curl -X POST https://www.strava.com/oauth/token \
      -F client_id=5 \
      -F client_secret=[REPLACE_WITH_YOUR_CLIENT_SECRET] \
      -F code=c498932e64136c8991a3fb31e3d1dfdf2f859357
      -F grant_type=authorization_code

## Get `access_token` from JSON result

{% highlight json %}
{
"token_type": "Bearer",
"access_token": "987654321234567898765432123456789",
"athlete": {
#{summary athlete representation}
},
"refresh_token": "1234567898765432112345678987654321",
"expires_at": 1531378346,
"state": "STRAVA"
}
{% endhighlight %}

## Done!

[strava-api-access]: https://developers.strava.com/docs/authentication/
[strava-api-token]: https://developers.strava.com/docs/authentication/#token-exchange
[strava developers]: https://developers.strava.com
[api application settings]: http://www.strava.com/settings/api
[authentication]: https://developers.strava.com/docs/authentication/
