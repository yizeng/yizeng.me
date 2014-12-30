---
layout: post
title: "Relationships between different versions of Selenium"
description: "Relationships between different versions of Selenium, including Selenium IDE, RC, WebDriver and Grid,
as well as other related terminologies, like PhantomJS, WebDriverJS, Appium, etc."
categories: [articles, popular]
tags: [phantomjs, selenium-webdriver]
alias: [/2014/04/25/]
utilities: fancybox, unveil
---
When I first started doing web UI automation a few years back,
it was a transition period that
[Selenium RC][Selenium RC] started deprecating,
[Selenium WebDriver][Selenium WebDriver] just got released,
[Watir][Watir] was dominating the Ruby world,
[WatiN][WatiN] and [Watij][Watij] were still under active development.
After all this time, things have been dramatically changed,
but left one thing that stays the same - confusing terminologies.

Therefore I made two graphs to help myself reduce the complexity.
It might not be fully correct or accurate, but definitely helped me to see the big picture.
Any corrections or suggestions would be greatly appreciated.

* Kramdown table of contents
{:toc .toc}

## Different versions of Selenium
{: #different-versions-of-selenium}

<a class="post-image" href="/assets/images/posts/2014-04-25-history-of-selenium-project.png" title="History of Selenium Project">
<img itemprop="image" data-src="/assets/images/posts/2014-04-25-history-of-selenium-project.png" src="/assets/js/unveil/loader.gif" alt="History of Selenium Project" />
</a>

### Selenium IDE
{: #selenium-ide}

Firefox add-on [Selenium IDE][Selenium IDE] allows users to record and re-play user actions in Firefox.
It supports exporting the recorded scripts into Selenium RC or Selenium WebDriver code.

### Selenium 1 / Selenium RC
{: #selenium-rc}

Also known as Selenium 1 incorrectly{% footnote 1 %},
[Selenium Remote Control][Selenium RC] is the first version of Selenium API,
which was generally known as "Selenium" without any version suffixes at the time.
After the release of second generation of Selenium,
it started to be called with version number or name in order to be distinguishable from the new API.
It is now officially deprecated
but still released within [Selenium WebDriver](#selenium-webdriver) library for backward compatibility purpose.

### Selenium 2 / Selenium WebDriver
{: #selenium-webdriver}

Selenium 2, a.k.a. [Selenium WebDriver][Selenium WebDriver], is the latest API in Selenium project,
which replaces Selenium RC with fundamentally different mechanisms and dominates web UI automation market right now.

### Selenium 3
{: #selenium-3}

The next release of Selenium project, which is only in staging at the time of writing.
One possible major change would be breaking the backward compatibility,
i.e. Selenium RC will be no longer a part of Selenium release.
More details can be followed and discussed in [this post][Selenium 3 Thread] on Selenium Developers' forum.

### WebDriver
{: #webdriver}

The term "WebDriver" might have different meanings in various contexts.

- Synonym for Selenium WebDriver / Selenium 2.

- A tool called "WebDriver" which was created independently then got merged into Selenium.
	+ According to [Selenium History][Selenium History], before the era of Selenium 2,
	  WebDriver was a different web testing tool coded by Simon Stewart separately,
	  while probably at the same time, developers within Google were making changes to Selenium RC.
	  After the meeting at GTAC,
	  the decision was made to merge these two projects together into the next generation of Selenium,
	  which is commonly referred as [Selenium 2 / Selenium WebDriver](#selenium-webdriver).
	  At the time, some people used the word "WebDriver" alone to address this new project,
	  so that users wouldn't get confused with then dominating project - Selenium RC.
	  <p></p>

- WebDriver Wire Protocol (JSON-over-HTTP wire protocol)
	+ [JsonWireProtocol][JsonWireProtocol] is the underlying technology used by client side drivers
	  to communicate with server side RemoteWebDriver.
	  <p></p>

- WebDriver W3C Specification
	+ With the rapid growth of Selenium WebDriver API, the maintainers made it a W3C specification,
	  which is currently released as [W3C working draft][WebDriver W3C Spec] called "WebDriver" again.
	  This is the specification defines the WebDriver standard API, which is what Selenium WebDriver implements.

### Selenium Grid
{: #selenium-grid}

[Selenium Grid][Selenium Grid] is a tool uses Selenium Server to execute either Selenium RC
or Selenium WebDriver tests in parallel on different machines.

### Selenium
{: #selenium}

Everything above can be referred as "Selenium" by different people, which in a way confuses the public.
All those terminologies are either a part of the current Selenium project, or were once inside Selenium project.

## Comparison of Selenium versions
{: #comparison-of-selenium-versions}

{% datatable %}
<tr>
	<th>Version</th>
	<th>Version</th>
	<th>Comparison</th>
</tr>
<tr>
	<td>Selenium 1</td>
	<td>Selenium RC</td>
	<td>
	Essentially the same thing.<br />
	Selenium 1 has never been an official name, but is commonly used in order to distinguish between versions.
	</td>
</tr>
<tr>
	<td>Selenium 2</td>
	<td>Selenium WebDriver</td>
	<td>
	Essentially the same thing.<br />
	The term "Selenium WebDriver" is now more commonly used.
	</td>
</tr>
<tr>
	<td>Selenium RC</td>
	<td>Selenium WebDriver</td>
	<td>
	Selenium RC is the predecessor of Selenium WebDriver.<br />
	It has been deprecated and now released inside Selenium WebDriver for backward compatibility.
	</td>
</tr>
<tr>
	<td>Selenium IDE</td>
	<td>Selenium RC/WebDriver</td>
	<td>
	Selenium IDE is a recording tool for automating Firefox, with the ability to generate simple RC/WebDriver code.<br />
	Selenium RC/WebDriver are frameworks to automate browsers programmatically.
	</td>
</tr>
<tr>
	<td>Selenium Grid</td>
	<td>Selenium WebDriver</td>
	<td>
	Selenium Grid is a tool to execute Selenium tests in parallel on different machines.<br />
	Selenium WebDriver is the core library to drive web browsers on a single machine.
	</td>
</tr>
{% enddatatable %}

## Selenium Relationships
{: #selenium-relationships}

<a class="post-image" href="/assets/images/posts/2014-04-25-anatomy-of-selenium-project.png" title="Anatomy of Selenium Project">
<img itemprop="image" data-src="/assets/images/posts/2014-04-25-anatomy-of-selenium-project.png" src="/assets/js/unveil/loader.gif" alt="Anatomy of Selenium Project" />
</a>

### Selenium RC Server / Selenium Server
{: #selenium-rc-server-selenium-server}

Selenium RC Server was the Java-based package to run Selenium RC tests.
With the release of Selenium WebDriver, Selenium (Standalone) Server was introduced as the super-set of the previous version,
so that tests can be executed remotely in Selenium Grid mode.
For Selenium WebDriver tests that are running locally, Selenium Server is not required.

### Selenium / PhantomJS
{: #selenium-phantomjs}

Being an open-source headless WebKit browser,
[PhantomJS][PhantomJS] needs a JavaScript implementation of the [WebDriver Wire Protocol][JsonWireProtocol] in order to work with Selenium WebDriver,
therefore [GhostDriver][GhostDriver] kicks in{% footnote 2 %}.
GhostDriver is used for automating PhantomJS browser,
which is similar to the relationship between ChromeDriver and Chrome browser in a sense.
However, there is a little bit difference that PhantomJS has GhostDriver integrated inside since 1.8{% footnote 3 %},
so that no separate GhostDriver binary will be required for running Selenium WebDriver projects.

### Selenium WebDriver / WebDriverJS
{: #selenium-webdriver-webdriverjs}

WebDriverJS is a term that generally considered as the JavaScript binding of Selenium WebDriver,
which confusingly may be referred to three different projects.

- Selenium project itself has an official JavaScript binding for node.js,
  which has a [wiki page][Selenium WebDriverJS] titled as "WebDriverJS" and can be installed using:

  > npm install selenium-webdriver

- There is another common third-party WebDriver protocol JS wrapper in the market, called "WebdriverJS" as well
  and can be installed with:

  > npm install webdriverjs

  It has been marketed by the name of [webdriver.io][webdriver.io]/[twitter.com/webdriverjs][WebdriverJS twitter].
  For more discussion about the differences between these two WebDriverJS projects,
  please have a look at webdriverjs' [issue#138](https://github.com/camme/webdriverjs/issues/138) on GitHub.

- [WD.js][WD.js] is also a WebDriver JavaScript client and can be found by command:

  > npm install wd

### Selenium / Appium, ios-driver, Selendroid
{: #selenium-appium-ios-driver-selendroid}

With the deprecation of Selenium's built-in [AndroidDriver][AndroidDriver] and [IPhoneDriver][iPhoneDriver]{% footnote 4 %},
third party libraries [Appium][Appium], [ios-driver][ios-driver] and [Selendroid][Selendroid] are recommended
for automating web applications on mobile devices.
They are based on WebDriver project,
using the same client API and communicate using the same [JSON-over-HTTP-based wire protocol][JsonWireProtocol],
but are capable of automating native and hybrid applications on mobile platforms{% footnote 5 %}.

### Selenium / Watir
{: #selenium-watir}

Similar to Selenium's development,
[Watir][Watir] has also experienced two generations,
Watir Classic and [Watir WebDriver][Watir WebDriver].
Watir Classic is to Watir as Selenium RC is to Selenium.
During the era of Selenium 1, it was known as "Watir" without any suffixes
and had nothing to do with Selenium project but both were popular at the time.
Originally Watir was designed in Ruby to support IE only and later expanded for other browsers{% footnote 6 %}.
Java and .NET versions were created by open source enthusiasts as third party projects, called [Watij][Watij] and [WatiN][WatiN].

However, some time after [Selenium WebDriver](#selenium-webdriver) hit the market,
Watir started to wrap around Selenium WebDirver's Ruby binding to a newer high-level API{% footnote 7 %},
which is now known as Watir WebDriver.
Both being open source frameworks,
Selenium WebDriver Ruby binding and Watir WebDriver are led by the same developer, Jari Bakken.

On the other hand, Watij and WatiN, are both no longer under active development unfortunately. The latest releases for
Watij and WatiN were made in 2010 and 2011 respectively.

## Additional reading
{: #additional-reading}

+ StackOverflow
	- [What's the relationship between selenium rc and webdriver?](http://stackoverflow.com/q/3619824/1177636)
	- [What's the relation between Selenium WebDriver and these other tools?](http://sqa.stackexchange.com/q/1580/5127)
	- [Difference between Selenium RC and WebDriver](http://stackoverflow.com/q/11535950/1177636)
	- [What are the different versions of Selenium, and which one should I get?](http://stackoverflow.com/q/4766020/1177636)
	- [What is the difference between Selenium Remote Control and Selenium Server?](http://stackoverflow.com/q/4774277/1177636)
	- [What's difference between protractor (Selenium webdriver) VS ghostdirver (phantomjs webdriver)?](http://stackoverflow.com/q/22455958/1177636)

+ Blog articles
	- [Introducing WebDriver](http://google-opensource.blogspot.co.nz/2009/05/introducing-webdriver.html) by Simon Stewart
	- [Watir gem relationships](http://jkotests.wordpress.com/2013/05/15/watir-gem-relationships/) by Justin Ko
	- [Watir, Selenium & WebDriver](http://watirmelon.com/2010/04/10/watir-selenium-webdriver/) by Alister Scott

{% footnotes %}
<p id="footnote-1">[1]: Comment made
<a href="http://stackoverflow.com/questions/21607800/setting-up-iedriver-with-perl#comment32649530_21607800">here</a> by Jim Evans.
{% reverse_footnote 1 %}
</p>
<p id="footnote-2">[2]: <a href="https://docs.google.com/presentation/d/1kBqhlcI1T4eGlFRFzt2Q5Dlk-lOW0OhQJJcpRUhz7Os">
Getting started with GhostDriver - SelConf2013 - Boston</a> by Ivan De Marino.
{% reverse_footnote 2 %}
</p>
<p id="footnote-3">[3]: <a href="http://phantomjs.org/release-1.8.html">PhantomJS 1.8 Release Notes</a>
{% reverse_footnote 3 %}
</p>
<p id="footnote-4">[4]: <a href="http://seleniumhq.wordpress.com/2013/12/24/android-and-ios-support/">
Android and iOS Support</a> (Official Selenium Blog).
{% reverse_footnote 4 %}
</p>
<p id="footnote-5">[5]: Answer made
<a href="http://stackoverflow.com/a/18729751/1177636">here</a> by Jim Evans.
{% reverse_footnote 5 %}
</p>
<p id="footnote-6">[6]:
<a href="http://watirmelon.com/2010/04/10/watir-selenium-webdriver/">Watir, Selenium &amp; WebDriver</a> by Alister Scott.
{% reverse_footnote 6 %}
</p>
<p id="footnote-7">[7]: Message from Jari Bakken in
<a href="http://rubyforge.org/pipermail/wtr-development/2009-October/001313.html">Watir mailing list</a> back in 2009.
{% reverse_footnote 7 %}
</p>
{% endfootnotes %}

[Selenium RC]: http://docs.seleniumhq.org/projects/remote-control/
[Selenium WebDriver]: http://docs.seleniumhq.org/projects/webdriver/
[WebDriver W3C Spec]: http://www.w3.org/TR/webdriver/
[Selenium Grid]: http://code.google.com/p/selenium/wiki/Grid2
[Selenium IDE]: http://docs.seleniumhq.org/projects/ide/
[Selenium History]: http://docs.seleniumhq.org/about/history.jsp
[Selenium WebDriver Documentation]: http://docs.seleniumhq.org/docs/03_webdriver.jsp
[Watir]: http://watir.com/
[Watin]: http://watin.org/
[Watij]: http://watij.com/
[Watir WebDriver]: http://watirwebdriver.com/
[PhantomJS]: http://phantomjs.org/
[GhostDriver]: https://github.com/detro/ghostdriver
[JsonWireProtocol]: http://code.google.com/p/selenium/wiki/JsonWireProtocol
[AndroidDriver]: http://code.google.com/p/selenium/wiki/AndroidDriver
[IPhoneDriver]: http://code.google.com/p/selenium/wiki/IPhoneDriver
[Appium]: http://appium.io/
[ios-driver]: http://ios-driver.github.io/ios-driver/
[Selendroid]: http://selendroid.io/mobileWeb.html
[Selenium 3 Thread]: https://groups.google.com/d/topic/selenium-developers/EdkY-QN5uqU/discussion
[Selenium WebDriverJS]: https://code.google.com/p/selenium/wiki/WebDriverJs
[webdriver.io]: http://webdriver.io/
[WebdriverJS twitter]: https://twitter.com/webdriverjs
[WD.js]: https://github.com/admc/wd
