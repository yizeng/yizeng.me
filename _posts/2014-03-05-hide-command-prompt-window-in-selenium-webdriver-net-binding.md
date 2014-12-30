---
layout: post
title: "Hide command prompt window in Selenium WebDriver .NET binding"
description: "How to hide ChromeDriver, IEDriver, or PhantomJSDriver's command prompt window in Selenium
WebDriver .NET binding using C#."
categories: [articles, popular]
tags: [c#, phantomjs, selenium-webdriver]
alias: [/2014/03/05/]
utilities: highlight
---
As of Selenium 2.40.0{% footnote 1 %},
Selenium WebDriver's .NET binding supports hiding the command prompt window created by ChromeDriver, IEDriver or PhantomJSDriver.
The following code snippets demonstrate how to achieve it in C#.

However, according to the developer{% footnote 2 %}, it is highly discouraged to use this option,
because this will make it hard to debug zombie driver processes when WebDriver code exits unexpectedly.
Also note that currently `PhantomJSDriver` has a constructor which takes in `PhantomJSDriverService` parameter alone,
while `ChromeDriver` and `InternetExplorerDriver` don't have this constructor overload.
A pull request has been made [here](https://github.com/SeleniumHQ/selenium/pull/180),
which will add this missing constructor overload to these two classes.

> Environment Tested:<br/>
> Windows 7, Selenium 2.40.0<br/>
> Chrome 33 + ChromeDriver 2.9, IE 10 + IEDriver 2.40.0, PhantomJSDriver 1.9.7

## ChromeDriver
{: #chromedriver}

{% prettify c# %}
var driverService = ChromeDriverService.CreateDefaultService();
driverService.HideCommandPromptWindow = true;

var driver = new ChromeDriver(driverService, new ChromeOptions());
{% endprettify %}

## InternetExplorerDriver
{: #internet-explorer-driver}

{% prettify c# %}
var driverService = InternetExplorerDriverService.CreateDefaultService();
driverService.HideCommandPromptWindow = true;

var driver = new InternetExplorerDriver(driverService, new InternetExplorerOptions());
{% endprettify %}

## PhantomJSDriver
{: #phantomjs-driver}

{% prettify c# %}
var driverService = PhantomJSDriverService.CreateDefaultService();
driverService.HideCommandPromptWindow = true;

var driver = new PhantomJSDriver(driverService);
{% endprettify %}

{% footnotes %}
<p id="footnote-1">
[1]: <a href="https://code.google.com/p/selenium/source/browse/dotnet/CHANGELOG?name=selenium-2.40.0#56">CHANGELOG</a> for Selenium 2.40.0.
{% reverse_footnote 1 %}
</p>
<p id="footnote-2">
[2]: <a href="https://groups.google.com/d/msg/selenium-users/3CwDvwiBmlM/X3BcnJzrGToJ">Comment</a> to "Hide the IEDriver command window" by Jim Evans.
{% reverse_footnote 2 %}
</p>
{% endfootnotes %}
