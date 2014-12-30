---
layout: post
title: "Take a screenshot on exception with Selenium C#'s EventFiringWebDriver"
description: "How to take a screenshot when exception is thrown
while executing WebDriver tests using Selenium .NET (C#) binding's EventFiringWebDriver class."
categories: [articles, popular]
tags: [c#, selenium-webdriver]
alias: [/2014/02/08/]
utilities: highlight
---
Apart from concrete browser's WebDriver implementations like
FirefoxDriver, ChromeDriver, PhantomJSDriver, etc.,
Selenium C# binding also provides one other type of driver called `EventFiringWebDriver`,
which wraps around any WebDriver instance and supports registering for events,
e.g. for logging things that WebDriver has been doing.

This class inherits from `IWebDriver` interface
but additionally provides events like `Navigating`, `ElementClicking`, `ExceptionThrown` etc.
It can be found within Selenium's support library WebDriver.Support.dll (under namespace "OpenQA.Selenium.Support.Events").
The source code is [here][EventFiringWebDriver.cs]
and the related tests exist [here][EventFiringWebDriverTest.cs].

Below gives an example of
how to take a screenshot when an exception is thrown while executing WebDriver tests
using Selenium C# binding's EventFiringWebDriver class.
Since the driver instance is a type of `EventFiringWebDriver`,
whenever an exception is thrown,
`ExceptionThrown` event will be triggered and a screenshot should be taken.

A completed example solution has been created on GitHub in [this][Example Repository] repository.
Code has been tested under environment Windows 7, Firefox 26 with Selenium 2.39.0.

{% prettify c# %}
private IWebDriver driver;

public void FooMethod() {
    var firingDriver = new EventFiringWebDriver(new FirefoxDriver());
    firingDriver.ExceptionThrown += firingDriver_TakeScreenshotOnException;

    driver = firingDriver;
    driver.Navigate().GoToUrl("http://yizeng.me");

    // try find a non-existent element where NoSuchElementException should be thrown
    driver.FindElement(By.CssSelector("#some_id .foo")); // a screenshot should be taken automatically
}

private void firingDriver_TakeScreenshotOnException(object sender, WebDriverExceptionEventArgs e) {
    string timestamp = DateTime.Now.ToString("yyyy-MM-dd-hhmm-ss");
    driver.TakeScreenshot().SaveAsFile("Exception-" + timestamp + ".png", ImageFormat.Png);
}
{% endprettify %}

[EventFiringWebDriver.cs]: https://code.google.com/p/selenium/source/browse/dotnet/src/support/Events/EventFiringWebDriver.cs
[EventFiringWebDriverTest.cs]: https://code.google.com/p/selenium/source/browse/dotnet/test/support/Events/EventFiringWebDriverTest.cs
[Example Repository]: https://github.com/yizeng/EventFiringWebDriverExamples
