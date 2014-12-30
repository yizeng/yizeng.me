---
layout: post
title: "Setup Stringer on Heroku"
description: "Brief note on how to setup stringer, a self-hosted anti-social RSS reader on Heroku."
categories: [notes]
tags: [stringer, heroku]
alias: [/2014/03/25/]
utilities: fancybox, unveil
---
This is a brief note on how to setup [Stringer][Stringer], a self-hosted anti-social RSS reader on Heroku.
Some of the following steps have already been covered by Project's [README file][README].

* Kramdown table of contents
{:toc .toc}

## Prerequisites
{: #prerequisites}

Stringer doesn't have any external dependencies,
but to download and setup it up on Heroku, two things are needed.

- [Git][Git Downloads]
- [Heroku][Heroku] account with valid credit card details (which won't be charged for free add-ons).

## Clone repository
{: #clone-repository}

If it is been forked, clone your own Stringer repository.
Otherwise clone the original repository like this:

	git clone https://github.com/swanson/stringer.git

## Install Heroku
{: #install-heroku}

1. Visit [Heroku Toolbelt][Heroku Toolbelt] page for different options depending on operating system.
2. Choose a way to download and install Heroku.

	- For example, on Linux Mint, run the following command in terminal to execute the installation shell script:

	  	wget -qO- https://toolbelt.heroku.com/install-ubuntu.sh | sh

	- For those with security concerns, detailed commands can be found
	in the script [here](https://toolbelt.heroku.com/install-ubuntu.sh) and executed manually.

## Configure Stringer
{: #configure-stringer}

1. Login into Heroku

   	heroku login

2. Create Heroku app

   	cd stringer
   	heroku create

3. Push to Heroku

   	git push heroku master

4. Configure

   	heroku config:set LOCALE=en
   	heroku config:set APP_URL=`heroku apps:info | grep -o 'http[^"]*'`
   	heroku config:set SECRET_TOKEN=`openssl rand -hex 20`

5. Restart

   	heroku run rake db:migrate
   	heroku restart

## Add custom domain
{: #add-custom-domain}

1. Detailed official documentation on how to add custom domain to this Heroku Stringer app is [here][Heroku Custom Domains].

   	heroku domains:add reader.yizeng.me

2. Visit domain registrar's "DNS Records" page and create a CNAME record pointing to Heroku app.<br />
   For example, record type is `CNAME`, host is `reader.yizeng.me`,
   answer is `yizeng-reader.herokuapp.com` and keep the default TTL, which is `300`.

## Add add-ons
{: #add-add-ons}

1. Add Scheduler add-ons

	To fetch RSS feeds automatically, [Heroku Scheduler](https://addons.heroku.com/scheduler) needs to be added to app.

		heroku addons:add scheduler
		heroku addons:open scheduler

	Then add a task called `rake fetch_feeds`
	and set a frequency to it in [Scheduler Dashboard](https://scheduler.heroku.com/dashboard).

	<a class="post-image" href="/assets/images/posts/2014-03-24-heroku-scheduler-dashboard.png">
	<img itemprop="image" data-src="/assets/images/posts/2014-03-24-heroku-scheduler-dashboard.png" src="/assets/js/unveil/loader.gif" alt="Heroku Scheduler Dashboard" />
	</a>

2. Add optional add-ons

	Some optional add-ons can also be added if interested.
	For example, [PG Backups](https://addons.heroku.com/pgbackups) is for backing up PostgreSQL database,
	[Papertrail](https://addons.heroku.com/papertrail) is for logging server status.
	Both of them have free plans available.

		heroku addons:add pgbackups:auto-week
		heroku addons:add papertrail:choklad

3. More settings and add-ons can be accessed from web user interface

<a class="post-image" href="/assets/images/posts/2014-03-24-heroku-stringer-settings-page.png">
<img itemprop="image" data-src="/assets/images/posts/2014-03-24-heroku-stringer-settings-page.png" src="/assets/js/unveil/loader.gif" alt="Heroku stringer settings page" />
</a>

## Update stringer
{: #update-stringer}

	git pull
	git push heroku master
	heroku run rake db:migrate
	heroku restart

## Clone existing stringer app
{: #clone-existing-stringer-app}

In order to clone the source of an existing application from Heroku using Git,
use the heroku git:clone command with the app name, mine is called `yizeng-reader` in this case.

	heroku git:clone -a yizeng-reader

## Troubleshooting
{: #troubleshooting}

Error while executing `git push heroku master`:

> Permission denied (publickey).<br />
> fatal: The remote end hung up unexpectedly

Solution from [StackOverflow](http://stackoverflow.com/q/4269922/1177636):

- Upload the public ssh key to Heroku:

  	heroku keys:add ~/.ssh/id_rsa.pub

- If no keys exist, create a new one:

  	heroku keys:add

[Stringer]: https://github.com/swanson/stringer
[README]: https://github.com/swanson/stringer/blob/master/README.md
[Git Downloads]: http://git-scm.com/downloads
[Heroku]: https://www.heroku.com/
[Heroku Toolbelt]: https://toolbelt.heroku.com/
[Heroku Custom Domains]: https://devcenter.heroku.com/articles/custom-domains