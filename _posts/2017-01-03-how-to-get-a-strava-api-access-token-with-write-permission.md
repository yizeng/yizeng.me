---
layout: post
title: "How to get a Strava API access token with write permission"
description: "How to get a Strava API access token with write permission without setting up OAuth environment."
categories: [tutorial]
tags: [strava]
alias: [/2017/01/03/]
---
I was playing around with Strava API V3 quite a bit
when Strava Developer Challenge 2016 was under way last September.

In order to use Strava API, the first step is to get an access token,
the process is rather straightforward as written in the [documentation][Strava-API-Access]:

> All calls to the Strava API require an access_token
  defining the athlete and application making the call.
  Any registered Strava user can obtain an access_token
  by first creating an application at [labs.strava.com/developers][Strava Developers].<br />
  The [API application settings][API application settings] page provides a public access token to get started.
  See the [Authentication][Authentication] page for more information
  about generating access tokens and the OAuth authorization flow.

However, Strava has defined four different types of permissions to access the API:

- **public**: default, private activities are not returned, privacy zones are respected in stream requests
- **write**: modify activities, upload on the user’s behalf
- **view_private**: view private activities and data within privacy zones
- **view_private,write**: both ‘view_private’ and ‘write’ access

The access token retrieved from Settings -> My API Application has the default permission,
which means it can only read public activities.
So the question I was facing was how to get an access token that can delete activities?

After some investigation,
the solution I found was a bit trickier than getting the default token.

Without an actual application set up,
I have to manually post the requests to authentication and exchange token.

[Strava-API-Access]: https://strava.github.io/api/#access
[Strava Developers]: labs.strava.com/developers
[API application settings]: http://www.strava.com/settings/api
[Authentication]: https://strava.github.io/api/v3/oauth
