---
layout: post
title: "Exclude your Selenium WebDriver traffic from Google Analytics"
description: "How to exclude your Selenium WebDriver testing traffic from Google Analytics"
category: [tutorial]
tags: [selenium, webdriver]
alias: [/2017/01/08]
utilities: highlight
---
For sites being tested by automated UI testing frameworks like
Selenium WebDriver or Watir,
developers may find it useful to exclude
the internal automated testing traffic from Google Analytics.

However, first things first, before talking about how to exclude,
the question would be "is it really necessary to use Selenium against production"?
Selenium is perfectly suited for testing production environment,
nevertheless, as the purpose of automated UI testing is to reduce manual workload,
does the production environment really need such a heavy testing plan
which needs to get Selenium involved in?

Normally live production servers might only need
some manual exploratory/smoke testing,
instead of intensive automated testing to mess around live databases
and slow down the servers.
In this case, if Selenium is used only against testing environment,
it would be relatively easy to exclude its traffic.
One approach would be using a different Google Analytics token from production,
so the analytics data's got separated out.
Another solution is to avoid executing Google Analytics snippet
if the site is deployed on testing servers.

Anyway, if it is really necessary to use Selenium against production,
Here are few solutions which might help exclude internal traffic from Google Analytics.
Some of them are just general approaches widely used,
while some may have Selenium involved specifically.

* Kramdown table of contents
{:toc .toc}

## General solutions
{: #general-solutions}

### Exclude IP/ISP
{: #exclude-ip-isp}

In Google Analytics official documentation's
'[Exclude internal traffic][Exclude internal traffic]' section,
a custom filter on certain IP address/range or ISP
is created in order to filter out internal traffic.

> Filter Type: Custom > Exclude

> Filter Field: Visitor IP Address

> Filter Pattern:
<br />For example, if the single IP address is 176.168.1.1,
then enter 176\.168\.1\.1.
<br />For example, if the range of IP addresses is 176.168.1.1-25
and 10.0.0.1-14, then enter
^176\.168\.1\.([1-9]|1[0-9]|2[0-5])$|^10\.0\.0\.([1-9]|1[0-4])$

However, this may also filter out data
that are not transferred by Selenium WebDriver.
On the other hand, if the tests are run on distributed CI systems
or environment with dynamic IP,
maintaining those IP addresses in Google Analytics setting
might be too much of a hassle.

### Edit hosts file
{: #edit-hosts-file}

Without changing Google Analytics settings from data-receiving end,
one other direction is to block GA's traffic being sent to its server.
To achieve it, editing hosts file on the machines
where the tests are run
would be a straightforward thing to do.
It requires certain permissions on testing environment,
and will block all traffic for all sites to Google Analytics,
hence this might not be as good as it sounds.

For more details about how to exclude Google Analytics
by editing hosts file, here are few posts worth reading:

- [Blocking Google Analytics and Statcounter](http://jesin.tk/block-google-analytics-statcounter/)
- [How to block google-analytics](http://www.dslreports.com/forum/r27645531-How-to-block-google-analytics)
- [Block Google Analytics](http://www.ccsf.edu/Policy/Privacy/ga.html)
- [How to block yourself from Google Analytics](http://www.veign.com/blog/2007/01/29/how-to-block-yourself-from-google-analytics/)
- [How to block your browser from sending information to Google Analytics](http://how-to.wikia.com/wiki/How_to_block_your_browser_from_sending_information_to_Google_Analytics)

### Custom variables (cookies) with JavaScript
{: #custom-variables-with-javascript}

## Selenium specific solutions
{: #selenium-specific-solutions}

### Disable JavaScript
{: #disable-javascript}

Since Google Analytics's tracking code is just a piece of JavaScript code,
disabling the JavaScript in browser seems to be one reasonable solution.

Seriously? Not really.
Modern websites nowadays use a lot of JavaScript to make things happen,
disabling it doesn't seem to be legitimate at all,
unless the target site doesn't use JavaScript.
Selenium WebDriver also requires JavaScript to function properly,
as a result, starting Selenium with JavaScript
disabled might cause all tests behave strangely.

Although a previous article
[Disable JavaScript using Selenium WebDriver][Disable JavaScript]
shows that this is achievable in some browsers,
this should not be encouraged anyway due to the side effects.

### Set special user agent and exclude it
{: #set-special-user-agent-and-exclude-it}

As most of the browsers' user agent can be set through Selenium,
wrap site's Google Analytics' snippet with an if-statement
to ignore some certain user agents
would be another possible approach to deal with it.

For example, Google Analytics snippet will only be active
if browser's user agent doesn't contain "phantomjs".
This would be useful when PhantomJS is used
as the automated testing browser,
because real users won't be using headless browsers like this,
therefore no code needs to be changed within Selenium WebDriver.

{% prettify javascript %}
if (!navigator.userAgent.match(/.*PhantomJS.*/gi)) {
    // Google Analytics's tracking snippet
}
{% endprettify %}

What about testing against other browsers then?
If the testing is done with ordinary browsers
like Chrome or Firefox, then it might not be wise
to ignore all Chrome/Firefox user agents.
An additional step is needed to set special testing
user agent when starting browsers using Selenium WebDriver.
A previous article
[Set user agent using Selenium WebDriver C# and Ruby][Set User Agent]
provides few sample snippets on how to set user agents
Note that user agent can't be set for IE using Selenium WebDriver,
therefore this approach is not going to work for IE.

Here, Firefox for instance, add something identifiable
(e.g "Selenium") into the user agent when launching,
then wrap Google Analytics's tracking code with
if-statement to ignore any user agents that contain word "Selenium" like above.

{% prettify ruby %}
# Environment:
# Linux Mint 15, Firefox 26, Selenium 2.39.0
require 'selenium-webdriver'

profile = Selenium::WebDriver::Firefox::Profile.new

original_ua = 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:26.0) Gecko/20100101 Firefox/26.0'
profile['general.useragent.override'] = original_ua + ' Selenium'

driver = Selenium::WebDriver.for :firefox, :profile => profile
{% endprettify %}

### Opt-out plugins
{: #opt-out-plugins}

Officially, Google provides [browser add-ons][GA opt-out add-on]
to opt-out Google Analytics.
With this plugin installed in the browser,
no Google Analytics data will be collected and used by Google.
It supports IE 7-10, Chrome, Firefox, Safari and Opera,
which unfortunately, means that this won't work test using PhantomJS.
Additionally, Selenium WebDriver cannot start IE with custom
add-ons installed, therefore this won't work for IE unless pre-install manually.

#### Chrome
The Chrome extension can be found within Chrome Store [here][Opt-out Chrome extension]
and downloaded using third party
sites like [Chrome Extension Downloader][Chrome Extension Downloader].
Save it somewhere locally and start Chrome using the following
Selenium WebDriver code.

{% prettify ruby %}
# Environment:
# Windows 7, Chrome 28.0.1500.95m, ChromeDriver 26.0.1383.0, Selenium 2.39.0
require 'selenium-webdriver'

Selenium::WebDriver::Chrome.driver_path = 'path_to_chromedriver'

profile = Selenium::WebDriver::Chrome::Profile.new
profile.add_extension("./Google-Analytics-Opt-out-Add-on-(by-Google)_v1.crx")

driver = Selenium::WebDriver.for :chrome, :profile => profile
{% endprettify %}

#### <a id="opt-out-plugin-firefox"></a>Firefox

In order to start Firefox with this add-on installed using Selenium WebDriver,
first try manually install it in Firefox to get the `xpi` file URL.
For example, [here](https://dl.google.com/analytics/optout/gaoptoutaddon_0.9.6.xpi)
is the latest version of `gaoptoutaddon_0.9.6.xpi`.
Then download it to local disk and use the following code to start Firefox.

{% prettify ruby %}
# Environment:
# Windows 7, Firefox 26, Selenium 2.39.0
require 'selenium-webdriver'

profile = Selenium::WebDriver::Firefox::Profile.new
profile.add_extension("./gaoptoutaddon_0.9.6.xpi")

driver = Selenium::WebDriver.for :firefox, :profile => profile
{% endprettify %}

### Use a proxy
{: #use-a-proxy}

https://github.com/jarib/browsermob-proxy-rb
https://groups.google.com/forum/#!msg/browsermob-proxy/l8s8K8H1WoA/pfqgCs7KUAYJ
http://stackoverflow.com/questions/14968861/is-the-browsermob-proxy-gem-for-ruby-not-working-for-anyone-else
https://github.com/lightbody/browsermob-proxy
http://www.adathedev.co.uk/2012/02/automating-web-performance-stats.html

## Comparison
<div class="data-table">
<table border="1">
    <tr>
        <th rowspan="2">Solution</th>
        <th>GA settings</th>
        <th>Environment</th>
        <th>Source code</th>
        <th>Testing code</th>
        <th rowspan="2">Pros</th>
        <th rowspan="2">Cons</th>
    </tr>
    <tr>
        <th colspan="4">Access required</th>
    </tr>
    <tr>
        <td class="center"><a href="#exclude-ip-isp">Exclude IP/ISP</a></td>
        <td class="center">✔</td>
        <td class="center"></td>
        <td class="center"></td>
        <td class="center"></td>
        <td>- Straightforward<br />
            - No code changes</td>
        <td>- High maintaining costs for environment using dynamic IP<br />
            - May also exclude traffic other than Selenium
        </td>
    </tr>
    <tr>
        <td class="center"><a href="#edit-hosts-file">Edit hosts</a></td>
        <td class="center"></td>
        <td class="center">✔</td>
        <td class="center"></td>
        <td class="center"></td>
        <td> - No code changes</td>
        <td>- Need permissions to setup on testing environment<br />
            - May also exclude traffic other than Selenium
        </td>
    </tr>
    <tr>
        <td class="center"><a href="#">Custom variables</a></td>
        <td class="center"></td>
        <td class="center"></td>
        <td class="center">✔</td>
        <td class="center">✔</td>
        <td></td>
        <td>- Source code changes required<br />
            - Extra test step in test case</td>
    </tr>
    <tr>
        <td class="center"><a href="#">Disable JavaScript</a></td>
        <td class="center"></td>
        <td class="center"></td>
        <td class="center"></td>
        <td class="center">✔</td>
        <td>- Straightforward<br />
            - Accurate
        </td>
        <td>- Make Selenium WebDriver barely usable<br />
            - Only support few browsers</td>
    </tr>
    <tr>
        <td class="center"><a href="#">Exclude special UA</a></td>
        <td class="center"></td>
        <td class="center"></td>
        <td class="center">✔</td>
        <td class="center">✔</td>
        <td>- Accurate<br />
            - Controllable
        </td>
        <td>- Source code changes required<br />
            - Need to set custom User Agent in Selenium code<br />
            - Not possible for IE</td>
    </tr>
    <tr>
        <td class="center"><a href="#">Opt-out plugin</a></td>
        <td class="center"></td>
        <td class="center"></td>
        <td class="center"></td>
        <td class="center">✔</td>
        <td>- Accurate<br />
            - Official
        </td>
        <td>- Need to load plugins in Selenium code<br />
            - Not possible for IE and PhantomJS</td>
    </tr>
    <tr>
        <td class="center"><a href="#">Use a proxy</a></td>
        <td class="center"></td>
        <td class="center"></td>
        <td class="center"></td>
        <td class="center">✔</td>
        <td>- Accurate<br />
            - Regardless of browser types
        </td>
        <td>- Need third party libraries<br />
            - Need to use together with Selenium</td>
    </tr>
</table>
</div>

[11](https://support.google.com/analytics/answer/1034840?hl=en)

[1111](https://github.com/jarib/browsermob-proxy-rb)

[1r44411](http://how-to.wikia.com/wiki/HoNw_to_block_your_browser_from_sending_information_to_Google_Analytics)

[132](http://sqa.stackexchange.com/questions/6859/how-do-you-block-google-analytics-from-selenium-automated-visits)

[312](http://stackoverflow.com/questions/20759860/disable-google-analytics-using-javascript-in-selenium/20760093#20760093)

[Exclude internal traffic]: https://support.google.com/analytics/answer/1034840?hl=en&ref_topic=1034830
[Disable JavaScript]: /2014/01/08/disable-javascript-using-selenium-webdriver/
[Disable JS in IEDriver]: http://stackoverflow.com/a/17292038/1177636
[Automation Atoms]: http://code.google.com/p/selenium/wiki/AutomationAtoms
[Issue 6672]: https://code.google.com/p/selenium/issues/detail?id=6672
[Set User Agent]: /2013/08/10/set-user-agent-using-selenium-webdriver-c-and-ruby/
[GA opt-out add-on]: https://tools.google.com/dlpage/gaoptout
[Chrome Extension Downloader]: http://chrome-extension-downloader.com/
[Opt-out Chrome extension]: https://chrome.google.com/webstore/detail/google-analytics-opt-out/fllaojicojecljbmefodhfapmkghcbnh?hl=en
