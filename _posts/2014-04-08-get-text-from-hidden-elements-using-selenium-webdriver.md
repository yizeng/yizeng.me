---
layout: post
title: "Get text from hidden elements using Selenium WebDriver"
description: "How to get text from hidden elements using Selenium WebDriver .NET, Ruby and Python bindings, using attribute
innerHTML, innerText or textContent."
categories: [tutorials]
tags: [c#, python, ruby, selenium webdriver]
last_updated: January 16, 2017
redirect_from:
  - /2014/04/08/
---
> Recently Updated - January 16, 2017

As defined in [WebDriver spec](https://www.w3.org/TR/webdriver/#dfn-interactable-element),
Selenium WebDriver will only interact with visible elements,
therefore the text of an invisible element will always be returned as an empty string.

However, in some cases, one may find it useful to get the hidden text,
which can be retrieved from element's `textContent`, `innerText` or `innerHTML` attribute,
by calling `element.attribute('attributeName')` or injecting JavaScript like `return arguments[0].attributeName`.

- `innerHTML` will return the inner HTML of this element, which **contains all HTML tags inside**.<br />
   For example, innerHTML for `<div>Hello <p>World!</p></div>` would be `Hello <p>World!</p>` instead of `Hello World!`.
- `textContent` and `innerText` will only retrieve all text content of its descendants **without any HTML tags**.
    + `textContent` is a W3C-compliant textContent property[^1], but sadly is not supported by IE[^2].
    + `innerText` is not part of the W3C DOM specification and not supported by Firefox.

Here is a brief demonstration on how to get text from hidden elements using Selenium WebDriver .NET, Ruby and Python bindings.

* Kramdown table of contents
{:toc .toc}

## Ruby

> Environment Tested:<br/>
> Mac OS Sierra, Ruby 2.3.1p112, Selenium 3.0.5, ChromeDriver 2.26, GeckoDriver 0.13<br />
> Chrome 55, Firefox 50.1, PhantomJS 1.9.8

{% highlight ruby %}
require 'selenium-webdriver'

DEMO_PAGE = <<-eos
    data:text/html,
    <p>Demo page for how to get text from hidden elements using Selenium WebDriver.</p>
    <div id='demo-div'>Demo div <p style='display:none'>with a hidden paragraph inside.</p><hr /><br /></div>
eos

driver = Selenium::WebDriver.for :phantomjs
driver.navigate.to(DEMO_PAGE)

demo_div = driver.find_element(:id, 'demo-div')

puts demo_div.attribute('innerHTML')
puts driver.execute_script("return arguments[0].innerHTML", demo_div)

puts demo_div.attribute('textContent')
puts driver.execute_script("return arguments[0].textContent", demo_div)

driver.quit
{% endhighlight %}

## C&#35;
{: #c-sharp}

> Environment Tested:<br/>
> Windows 7, Selenium 2.40.0, PhantomJS 1.9.7

{% highlight c# %}
using System;
using OpenQA.Selenium;
using OpenQA.Selenium.PhantomJS;
using OpenQA.Selenium.Support.Extensions;

namespace GetHiddenText {

    internal class Program {

        private const string DEMO_PAGE = @"data:text/html,
            <p>Demo page for how to get text from hidden elements using Selenium WebDriver.</p>
            <div id='demo-div'>Demo div <p style='display:none'>with a hidden paragraph inside.</p><hr /><br /></div>";

        internal static void Main(string[] args) {
            IWebDriver driver = new PhantomJSDriver();
            driver.Navigate().GoToUrl(DEMO_PAGE);

            IWebElement demoDiv = driver.FindElement(By.Id("demo-div"));

            Console.WriteLine(demoDiv.GetAttribute("innerHTML"));
            Console.WriteLine(driver.ExecuteJavaScript<string>("return arguments[0].innerHTML", demoDiv));

            Console.WriteLine(demoDiv.GetAttribute("textContent"));
            Console.WriteLine(driver.ExecuteJavaScript<string>("return arguments[0].textContent", demoDiv));

            driver.Quit();
        }
    }
}
{% endhighlight %}

## Python

> Environment Tested:<br/>
> Windows 7, Python 2.7.5, Selenium 2.41.0, PhantomJS 1.9.7<br/>
> Linux Mint 16, Python 2.7.5+, Selenium 2.41.0, PhantomJS 1.9.7

{% highlight python %}
from selenium import webdriver

DEMO_PAGE = '''data:text/html,
    <p>Demo page for how to get text from hidden elements using Selenium WebDriver.</p>
    <div id='demo-div'>Demo div <p style='display:none'>with a hidden paragraph inside.</p><hr /><br /></div>'''

driver = webdriver.PhantomJS()
driver.get(DEMO_PAGE)

demo_div = driver.find_element_by_id("demo-div")

print demo_div.get_attribute('innerHTML')
print driver.execute_script("return arguments[0].innerHTML", demo_div)

print demo_div.get_attribute('textContent')
print driver.execute_script("return arguments[0].textContent", demo_div)

driver.quit
{% endhighlight %}

## Output

>Demo div &lt;p style="display:none">with a hidden paragraph inside.&lt;/p>&lt;hr>&lt;br><br />
>Demo div &lt;p style="display:none">with a hidden paragraph inside.&lt;/p>&lt;hr>&lt;br><br />
>
>Demo div with a hidden paragraph inside.<br />
>Demo div with a hidden paragraph inside.

[^1]: W3C-compliant <a href="http://www.w3.org/TR/2004/REC-DOM-Level-3-Core-20040407/core.html#Node3-textContent">textContent </a>property
[^2]: W3C DOM Compatibility<a href="http://quirksmode.org/dom/html/#t06">#textContent</a>
