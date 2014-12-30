---
layout: post
title: "Setup a Selenium WebDriver Ruby project on Travis CI"
description: "How to setup an automated UI testing project on Travis CI
using Selenium WebDriver Ruby binding with headless PhantomJS."
categories: [articles, popular]
tags: [github, phantomjs, ruby, selenium-webdriver, travis-ci]
alias: [/2013/06/15/]
last_updated: April 20, 2014
utilities: fancybox, highlight, unveil
---
[Travis CI][Travis CI] is a hosted, distributed [continous intergration][CI] service for building GitHub projects.
It is free of charge for open source GitHub projects in various languages,
including C, C++, Java, JavaScript, Python, Ruby and few more{% footnote 1 %}.

This article will demonstrate how to setup an automated UI testing project
using Selenium WebDriver Ruby binding with headless PhantomJS browser.

* Kramdown table of contents
{:toc .toc}

## Create a GitHub repository
{: #create-a-github-repository}

A public GitHub repository is needed in order to be built on Travis CI for free.
New open-source projects can be created at GitHub's '[Create a New Repository][Create a New Repository]' page.

## Create a Selenium WebDriver Ruby project
{: #create-a-selenium-webdriver-ruby-project}

### Project Structure
{: #project-structure}

There are no requirements for how Selenium WebDriver Ruby project should be set up.
Hence here is how this sample Selenium Ruby project is structured:

	/root                       -- root of the repository
	    /test                   -- folder contains the sample test
	        test_home_page.rb   -- sample test file
	    .travis.yml             -- configuration file for Travis CI
	    README.md               -- description of the project
	    Rakefile                -- Rakefile

### Create a UI test
{: #create-a-ui-test}

- `Test::Unit` framework is used as the testing framework in this example.
- Headless WebKit [PhantomJS][PhantomJS] will be the browser to run the UI tests.
- PhantomJS binary should be installed by default on
[Travis CI servers][Travis CI servers], which is `1.9.7` as of 20/04/2014.
- Travis CI supports tests which require GUI, where some setup for `xvfb` are needed{% footnote 2 %}.

Here is a sample test file called `test_home_page.rb`:
{% highlight ruby %}
require 'selenium-webdriver'
require 'test/unit'

module Test
  class TestHomePage < Test::Unit::TestCase

    def setup
      @driver = Selenium::WebDriver.for :phantomjs
      @driver.navigate.to('http://yizeng.me')
    end

    def teardown
      @driver.quit
    end

    def test_home_page_title
      assert_equal('Yi Zeng', @driver.title)
    end
  end
end
{% endhighlight %}

### Add Rakefile
{: #add-rakefile}

Travis CI uses `Rakefile` to build project and execute the tests, if it is not present, build will fail like this:

	$ rake
	rake aborted!
	No Rakefile found (looking for: rakefile, Rakefile, rakefile.rb, Rakefile.rb)
	The command "rake" exited with 1.

Therefore here comes the sample Rakefile:

{% highlight ruby %}
require 'rake/testtask'

task :default => [:test]
Rake::TestTask.new(:test) do |test|
  test.libs << 'test'

  # ensure the sample test file is included here
  test.test_files = FileList['test/test_*.rb']

  test.verbose = true
end
{% endhighlight %}

### Add .travis.yml
{: #add-travis-yml}

Travis CI uses `.travis.yml` file in the root of the repository to learn about the project, which for instance includes:

- Programming language of the project
- Build setup and cleanup
- Commands to execute the build

The sample testing project here is written in Ruby, so Ruby configurations will be used in `.travis.yml`.
Detailed official documentation for building Ruby projects can be found [here](http://about.travis-ci.org/docs/user/languages/ruby/).
In order to validate it, [Travis Lint][Travis Lint] would be a handy tool, while
the simplest way is just to go to [Travis WebLint][Travis WebLint] and paste the content in.

{% prettify yaml %}
# Sample .travis.yml file:
language: ruby

rvm: # the Ruby versions to be used
  - 2.1.0
  - 2.0.0
  - 1.9.3

before_install:
  - gem install selenium-webdriver
{% endprettify %}

## Push to Github
{: #push-to-github}

Once the repository is properly created, push it to Github.

## Login to Travis CI and enable hook
{: #login-to-travis-ci-and-enable-hool}

1. Login to Travis CI with the GitHub account of this repository.
2. Visit [Travis CI profile][Travis CI profile] and find the repository.
If the repository does not appear on the list, make sure
	- It is not a private repository
	- Travis CI has been synced with GitHub (click "Sync now" if necessary)
3. Enable the hook for this repository.

<a class="post-image" href="/assets/images/posts/2013-06-09-enable-hook-on-travis-ci.gif">
<img itemprop="image" data-src="/assets/images/posts/2013-06-09-enable-hook-on-travis-ci.gif" src="/assets/js/unveil/loader.gif" alt="Enable hook on Travis CI" />
</a>

## Run project on Travis CI
{: #run-project-on-travis-ci}

Travis CI should be able to build to the project automatically whenever new changesets are pushed to GitHub.
However, to kick off a test run manually:

- From Travis CI project page

> 1. Find this project's page on Travis CI
> 2. Click the refresh icon

- From GitHub project settings

> 1. Go to project's settings page on GitHub
> 2. Select tab `Webhooks & Services` (url: https://github.com/[GITHUB_USERNAME]/[REPO_NAME]/settings/hooks)
> 3. Click 'Configure services' button
> 4. Find `Travis` down to bottom
> 5. Click `Test Hook` button

## Analyze results on Travis CI
{: #analyze-results-on-travis-ci}

### Project page
{: #project-page}

The project page on Travis CI is: `https://travis-ci.org/[GITHUB_USERNAME]/[REPO_NAME]`

<a class="post-image" href="/assets/images/posts/2013-06-15-results-page-on-travis-ci.gif">
<img itemprop="image" data-src="/assets/images/posts/2013-06-15-results-page-on-travis-ci.gif" src="/assets/js/unveil/loader.gif" alt="Results page on Travis CI" />
</a>

### Build log
{: #build-log}

Clicking each job number will open up the build log for that particular job,
which contains all console output produced during the build.

### Test Results
{: #test-results}

Test results are shown in the `rake` section of the build log.
For example, here are the test results inside [this particular job's build log](https://travis-ci.org/yizeng/setup-selenium-webdriver-ruby-project-on-travis-ci/jobs/8109067):

	$ rake
	/home/travis/.rvm/rubies/ruby-2.0.0-p0/bin/ruby -I"lib:test" -I"/home/travis/.rvm/gems/ruby-2.0.0-p0/gems/rake-10.0.4/lib" "/home/travis/.rvm/gems/ruby-2.0.0-p0/gems/rake-10.0.4/lib/rake/rake_test_loader.rb" "test/test_home_page.rb" 
	Run options:

	# Running tests:

	Finished tests in 1.078374s, 0.9273 tests/s, 0.9273 assertions/s.
	1 tests, 1 assertions, 0 failures, 0 errors, 0 skips

	ruby -v: ruby 2.0.0p0 (2013-02-24 revision 39474) [x86_64-linux]
	The command "rake" exited with 0.

### Build status images
{: #build-status-images}

Travis CI provides [build status images][build status images] for projects,
which are encouraged to be added to project sites or README files as good software development practices.

The status image can be found at `https://travis-ci.org/[GITHUB_USERNAME]/[REPO_NAME].png`,
with branches can be specified by URL query string like `?branch=master,staging,production` optionally.

Alternatively, in the repository page of Travis CI, click settings icon button, then select `Status Image`,
a dialog with all the options will be displayed, as shown in the screenshot below:

<a class="post-image" href="/assets/images/posts/2013-07-05-travis-ci-status-image-options.gif">
<img itemprop="image" data-src="/assets/images/posts/2013-07-05-travis-ci-status-image-options.gif" src="/assets/js/unveil/loader.gif" alt="Travis CI status image options" />
</a>

The sample project's current status is: <a class="image-link" href="https://travis-ci.org/yizeng/setup-selenium-webdriver-ruby-project-on-travis-ci" title="Travis CI build status"><img src="https://travis-ci.org/yizeng/setup-selenium-webdriver-ruby-project-on-travis-ci.png" alt="Travis CI build status" /></a>

[Travis CI]: https://travis-ci.org/
[CI]: http://en.wikipedia.org/wiki/Continuous_integration
[Create a New Repository]: https://github.com/repositories/new
[PhantomJS]: http://phantomjs.org/
[Travis CI servers]: http://about.travis-ci.org/docs/user/ci-environment/
[Travis Lint]: http://about.travis-ci.org/docs/user/travis-lint/
[Travis WebLint]: http://lint.travis-ci.org/
[Travis CI profile]: https://travis-ci.org/profile
[build status images]: http://about.travis-ci.org/docs/user/status-images/

{% footnotes %}
<p id="footnote-1">
[1]: A list of supported languages can be found <a href="http://docs.travis-ci.com/user/languages/">here</a>.
{% reverse_footnote 1 %}
</p>
<p id="footnote-2">
[2]: <a href="http://docs.travis-ci.com/user/gui-and-headless-browsers/#Using-xvfb-to-Run-Tests-That-Require-GUI-(e.g.-a-Web-browser)">Using xvfb to Run Tests That Require GUI (e.g. a Web browser) </a>
{% reverse_footnote 2 %}
</p>
{% endfootnotes %}