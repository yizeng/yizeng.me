---
layout: post
title: "Get a Strava API access token with write permission"
description: "How to get a Strava API access token with write permission quickly without coding up an actual OAuth2 authorization flow."
categories: [tutorial]
tags: [strava]
alias: [/2017/01/11/]
utilities: fancybox, unveil
---
While Strava Developer Challenge 2016 was under way last September,
I spent quite some time playing around with Strava API V3.

In order to access the API, the first step is to get an access token,
the process is rather straightforward as shown in [documentation][Strava-API-Access]:

> All calls to the Strava API require an `access_token`
  defining the athlete and application making the call.
  Any registered Strava user can obtain an `access_token`
  by first creating an application at [labs.strava.com/developers][Strava Developers].<br /><br />
  The [API application settings][API application settings] page provides a public access token to get started.
  See the [Authentication][Authentication] page for more information
  about generating access tokens and the OAuth authorization flow.

However, Strava has defined four different types of permissions to access the API:

- **`public`**: default, private activities are not returned, privacy zones are respected in stream requests
- **`write`**: modify activities, upload on the user’s behalf
- **`view_private`**: view private activities and data within privacy zones
- **`view_private,write`**: both ‘view_private’ and ‘write’ access

The access token retrieved via `Settings` -> `My API Application` has the default permission,
which means it can only read public activities.
But I was writing some simple scripts to delete and upload new activities,
which requires an access token with write permission.
So how to quickly get a Strava access token with write access
without code up a web application with OAuth2 authorization flow?

After some investigation, here are the steps as below.

## Get authorization code

1. Create a request URL for Strava authorization,
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
            <td>'public', 'write', 'view_private', 'view_private,write'  </td>
        </tr>
    </table>
    </div>

        http://www.strava.com/oauth/authorize?client_id=6414&response_type=code&redirect_uri=http://localhost/exchange_token&approval_prompt=force&scope=write

2. Go to above URL in browser. (HTTP GET)
3. Login to Strava and click 'Authorize' if needed.
4. Browser should go to 404 as `http://localhost/exchange_token` doesn't exist.
5. Copy the authorization code from URL. For example,

        http://localhost/exchange_token?state=&code=c498932e64136c8991a3fb31e3d1dfdf2f859357

   The authorization code for next step is `c498932e64136c8991a3fb31e3d1dfdf2f859357`.

   <a class="post-image" href="/assets/images/posts/2017-01-11-get-strava-authorization-code.gif">
   <img itemprop="image" data-src="/assets/images/posts/2017-01-11-get-strava-authorization-code.gif" src="/assets/js/unveil/loader.gif" alt="Get authorization code from Strava" />
   </a>

## Exchange Token

Use any HTTP Rest Client to perform POST to `https://www.strava.com/oauth/token`
as defined in documentation [here][Strava-API-Token].

- **`client_id`**: your application’s ID, obtained during registration<br />
- **`client_secret`**: your application’s secret, obtained during registration<br />
- **`code`**: authorization code from last step

      $ curl -X POST https://www.strava.com/oauth/token \
      -F client_id=5 \
      -F client_secret=7b2946535949ae70f015d696d8ac602830ece412 \
      -F code=5919f3e385c6cb039bcc809f27d1e535e36b7a91

## Get `access_token` from JSON result

{% prettify json %}
{  
   "access_token":"dbf62f847d0f3234d8257bd04844f0b25ddb69ed",
   "token_type":"Bearer",
   "athlete":{  
      "id":9123806,
      "username":"yizeng",
      "resource_state":3,
      "firstname":"Yi",
      "lastname":"Zeng",
      "city":"Christchurch",
      "state":"Canterbury",
      "country":"New Zealand",
      "sex":"M",
      "premium":false,
      "created_at":"2015-05-09T13:56:02Z",
      "updated_at":"2017-01-11T04:29:52Z",
      ...
   }
}
{% endprettify %}

## Done!

[Strava-API-Access]: https://strava.github.io/api/#access
[Strava-API-Token]:  http://strava.github.io/api/v3/oauth/#token-exchange
[Strava Developers]: labs.strava.com/developers
[API application settings]: http://www.strava.com/settings/api
[Authentication]: https://strava.github.io/api/v3/oauth
