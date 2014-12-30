---
layout: post
title: "Run Selenium WebDriver UI tests against a Jekyll site on Travis CI"
description: "How to run Selenium WebDrvier Cucumber UI tests against a Jekyll
site built locally on Travis CI."
categories: [articles, popular]
tags: [cucumber, jekyll, travis-ci, selenium-webdriver]
alias: [/2013/11/17/]
utilities: highlight
---
Imagine there is a [Jekyll][Jekyll] site repository
which has some [Selenium WebDriver][Selenium WebDriver] UI tests written with BDD framework [Cucumber][Cucumber] inside.
After each commit, one may find it beneficial to run those tests on [Travis CI][Travis CI]
against this Jekyll site in that particular commit, as part of the continuous integration process.

Instead of running those tests against the live production site each time{% footnote 1 %},
a better way would be to build the site on Travis CI itself, and run the tests against localhost directly.

* Kramdown table of contents
{:toc .toc}

## Implement tests
{: #implement-tests}

First of all, there should be some UI tests inside the repository,
which can be written using [Selenium WebDriver][Selenium WebDriver], [Watir][Watir],
or any other suitable automation frameworks,
with or without BDD/ATDD frameworks like [Cucumber][Cucumber], [Capybara][Capybara], etc.
To setup a simple Selenium WebDriver Ruby project on Travis CI,
a [previous blog article][previous blog article] would be useful.

Since the site will be built on Travis CI locally, so the URL will be
`localhost:4000` instead of the actual live site URL.
Bear in mind that port number 4000 can be made configurable if desired.

## Install gems
{: #install-gems}

Before building Jekyll and running Selenium UI tests on Travis CI,
some necessary gems need to be installed.
To do so, within the `before_install` section of `.travis.yml` file,
add in the following commands to install gems, in this case
`jekyll`, `cucumber` and `selenium-webdriver`.

{% prettify yaml %}
before_install:
  # other before_install steps

  # install gems
  - gem install jekyll cucumber selenium-webdriver
{% endprettify %}

Alternatively, adding a `Gemfile` inside the repository would also do the job, which should be picked up by Travis Ci automatically.

{% prettify yaml %}
source 'https://rubygems.org'

gem 'jekyll'
gem 'cucumber'
gem 'selenium-webdriver'
{% endprettify %}

## Start Jekyll web server
{: #start-jekyll-web-server}

To build the Jekyll site locally on Travis CI,
add a command to serve Jekyll site with `--detach` option in `.travis.yml`'s `before_script` section,
which is available since [Jekyll 1.2.0][Jekyll 1.2.0] or later.
With this `--detach` option, web server will be running in background,
so that any subsequent commands can be continued and whole Travis CI build won't be hanging.

{% prettify yaml %}
before_script:
  - jekyll serve --detach
  - sleep 3 # give Web server some time to bind to sockets, etc
{% endprettify %}


## Run UI tests
{: #run-ui-tests}

In `.travis.yml`'s `script` section, specify the commands to run those cucumber tests.

{% prettify yaml %}
script:
  -  cucumber ./_rake/features/
{% endprettify %}

{% footnotes %}
<p id="footnote-1">
[1]: Since only the commits in master/gh-pages branches will affect the production site,
running tests against production for branches that don't change production is somewhat redundant.
{% reverse_footnote 1 %}
</p>
{% endfootnotes %}

[Jekyll]: http://jekyllrb.com/
[Travis CI]: https://travis-ci.org/
[Selenium WebDriver]: http://docs.seleniumhq.org/
[Watir]: http://watir.com/
[Cucumber]: http://cukes.info/
[Capybara]: http://jnicklas.github.io/capybara/
[previous blog article]: /2013/06/15/setup-a-selenium-webdriver-ruby-project-on-travis-ci/
[Jekyll 1.2.0]: http://jekyllrb.com/news/2013/09/06/jekyll-1-2-0-released/
