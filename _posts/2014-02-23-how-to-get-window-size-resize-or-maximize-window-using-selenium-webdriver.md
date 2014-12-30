---
layout: post
title: "How to get window size, resize or maximize window using Selenium WebDriver"
description: "How to get browser window size, resize or maximize window
using Selenium WebDriver C#, Ruby and Python bindings."
categories: [articles, popular]
tags: [c#, python, ruby, selenium-webdriver]
alias: [/2014/02/23/]
utilities: highlight
---
Selenium WebDriver supports getting the browser window size,
resizing and maximizing window natively from its API,
no JavaScript injections like `window.resizeTo(X, Y);` are necessary any more.
Below shows the examples on how to achieve this in Selenium WebDriver C#, Ruby and Python bindings.

* Kramdown table of contents
{:toc .toc}

## Ruby
{: #ruby}

In Ruby binding, window size can be retrieved from method `driver.manage.window.size`,
which is a type of struct `Selenium::WebDriver::Dimension` defined [here][Ruby Dimension Class].
To resize a window, one solution is to create a new `Dimension` object
and assign it to property `driver.manage.window.size`.
Alternatively, Ruby binding has provided a `driver.manage.window.resize_to()` method,
which is equivalent to `#size=`, but accepts width and height arguments according to API [here][Ruby resize_to()].

> Environment Tested:<br/>
> Windows 7, Ruby 2.0.0p247, Selenium 2.39.0, Firefox 26.0

### Example
{: #ruby-example}

{% highlight ruby %}
require 'selenium-webdriver'

# get initial window size
driver = Selenium::WebDriver.for :firefox
puts driver.manage.window.size

# set window size using Dimension struct
target_size = Selenium::WebDriver::Dimension.new(1024, 768)
driver.manage.window.size = target_size
puts driver.manage.window.size

# resize window
driver.manage.window.resize_to(480, 320)
puts driver.manage.window.size

# maximize window
driver.manage.window.maximize
puts driver.manage.window.size

driver.quit
{% endhighlight %}

### Output
{: #ruby-output}

>&#35;&lt;struct Selenium::WebDriver::Dimension width=1341, height=810&gt;<br />
>&#35;&lt;struct Selenium::WebDriver::Dimension width=1024, height=768&gt;<br />
>&#35;&lt;struct Selenium::WebDriver::Dimension width=480, height=320&gt;<br />
>&#35;&lt;struct Selenium::WebDriver::Dimension width=1804, height=1096&gt;

## C&#35;
{: #c-sharp}

Similarly in C# binding, a browser window's size can be found out using `driver.Manage().Window.Size` property.
The same [IWindow interface][IWindow interface] also defines method `Maximize()` for maximizing the window.
Although this interface doesn't provide a function to resize window directly like Ruby binding,
it can be done by setting the `Size` property using `System.Drawing.Size` object{% footnote 1 %}.

> Environment Tested:<br />
> Windows 7, Selenium 2.39.0, Firefox 26.0

### Example
{: #c-sharp-example}

{% prettify c# %}
using System;
using System.Drawing;
using OpenQA.Selenium;
using OpenQA.Selenium.Firefox;

namespace BrowserWindowSizeApp {

    internal class Program {

        internal static void Main(string[] args) {

            // get initial window size
            IWebDriver driver = new FirefoxDriver();
            Console.WriteLine(driver.Manage().Window.Size);

            // set window size
            driver.Manage().Window.Size = new Size(480, 320);
            Console.WriteLine(driver.Manage().Window.Size);

            // maximize window
            driver.Manage().Window.Maximize();
            Console.WriteLine(driver.Manage().Window.Size);

            driver.Quit();
        }
    }
}
{% endprettify %}

### Output
{: #c-sharp-output}

>{Width=1341, Height=810}<br />
>{Width=480, Height=320}<br />
>{Width=1804, Height=1096}

## Python
{: #python}

Unlike C# and Ruby bindings, Python binding doesn't offer properties to get/set window size,
all get/set/maximize actions are available using methods defined in [selenium.webdriver.remote.webdriver][Python driver class].

> Environment Tested:<br/>
> Window 7, Python 2.7, Selenium 2.40.0, Firefox 26.0

### Example
{: #python-example}

{% highlight python %}
from selenium import webdriver

# get initial window size
driver = webdriver.Firefox()
print driver.get_window_size()

# set window size
driver.set_window_size(480, 320)
print driver.get_window_size()

# maximize window
driver.maximize_window()
print driver.get_window_size()

driver.quit()
{% endhighlight %}

### Output
{: #python-output}

>{u'width': 1341, u'height': 810}<br />
>{u'width': 480, u'height': 320}<br />
>{u'width': 1804, u'height': 1096}

## Comparison
{: #comparison}

{% datatable %}
<tr><th colspan="2">Get window size</th></tr>
<tr>
	<td>Ruby</td>
	<td>driver.manage.window.size</td>
</tr>
<tr>
	<td>C#</td>
	<td>driver.Manage().Window.Size;</td>
</tr>
<tr>
	<td>Python</td>
	<td>driver.get_window_size()</td>
</tr>
<tr><th colspan="2">Set window size</th></tr>
<tr>
	<td>Ruby</td>
	<td>
		size = Selenium::WebDriver::Dimension.new(width, height)<br />
		driver.manage.window.size = size
	</td>
</tr>
<tr>
	<td>C#</td>
	<td>
		System.Drawing.Size windowSize = new System.Drawing.Size(width, height);<br />
		driver.Manage().Window.Size = windowSize;
	</td>
</tr>
<tr>
	<td>Python</td>
	<td>-</td>
</tr>
<tr><th colspan="2">Resize window</th></tr>
<tr>
	<td>Ruby</td>
	<td>driver.manage.window.resize_to(width, height)</td>
</tr>
<tr>
	<td>C#</td>
	<td>-</td>
</tr>
<tr>
	<td>Python</td>
	<td>driver.set_window_size(width, height)</td>
</tr>
<tr><th colspan="2">Maximize window</th></tr>
<tr>
	<td>Ruby</td>
	<td>driver.manage.window.maximize</td>
</tr>
<tr>
	<td>C#</td>
	<td>driver.Manage().Window.Maximize();</td>
</tr>
<tr>
	<td>Python</td>
	<td>driver.maximize_window()</td>
</tr>
{% enddatatable %}

## Related source code
{: #related-source-code}

- [Ruby - window.rb](https://code.google.com/p/selenium/source/browse/rb/lib/selenium/webdriver/common/window.rb)
- [Ruby - Dimension struct](https://code.google.com/p/selenium/source/browse/rb/lib/selenium/webdriver.rb)
- [C# - IWindow interface][IWindow interface]
- [Python - webdriver.py](https://code.google.com/p/selenium/source/browse/py/selenium/webdriver/remote/webdriver.py)

{% footnotes %}
<p id="footnote-1">
[1]: Adding "System.Drawing" assembly reference to project is required first.
{% reverse_footnote 1 %}
</p>
{% endfootnotes %}

[Ruby Dimension Class]: http://selenium.googlecode.com/git/docs/api/rb/Selenium/WebDriver/Dimension.html
[Ruby resize_to()]: http://selenium.googlecode.com/git/docs/api/rb/Selenium/WebDriver/Window.html#resize_to-instance_method
[IWindow interface]: https://code.google.com/p/selenium/source/browse/dotnet/src/webdriver/IWindow.cs
[Python driver class]: http://selenium.googlecode.com/git/docs/api/py/webdriver_remote/selenium.webdriver.remote.webdriver.html