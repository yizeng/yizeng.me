---
layout: post
title: "Why you shouldn't start learning Selenium by automating Google's products?"
description: "Why people shouldn't start learning Selenium by automating Google's applications like Gmail, Google Maps etc."
categories: [articles]
tags: [selenium-webdriver]
alias: [/2014/07/19/]
utilities: highlight, show-hidden
---
Whenever I see questions on StackOverflow about UI automation
against Google's products (especially Gmail, Google maps, Youtube, etc.),
the first thing pops up in my head would be - do those OPs work for Google? I guess not.
Then why are there so many people interested in automating Google's applications from UI?

My wild guess is that this mainly includes two situations:

- Someone who starts off learning Selenium and has decided to automate Google search as a starting point.
  Since Google homepage has a reasonably clean and simple UI,
  people have the reason to believe that Google could be the best site for learning Selenium.
  After playing with "Google Search" scenario, they might continue to try out automating Gmail or Youtube.
- Someone who needs to access Google services like Gmail, Google maps as part of the job,
  which can be either testing projects or applications involving browser automation.

Well, for whatever the reason is, people should rarely need to automated Google's applications from UI level,
especially for those who have just started learning Selenium.

* Kramdown table of contents
{:toc .toc}

## Don't automate Google's products
{: #dont-automate-googles-products}

### Google search use case is too easy
{: #google-search-use-case-is-too-easy}

Almost all Selenium 101 tutorials use Google search scenario, which seems like one the of easiest use cases.

> 1. Send keys to Google's search box
> 2. Submit
> 3. Check the title in browser window

This is indeed a reasonable starting point for people who have just started coding with Selenium,
as it provides an intuitive way to demonstrate what Selenium does - "Selenium automates browsers"{% footnote 1 %}.

However, considering the fact that it looks so easy
purely because it was deliberately simplified for educational purposes,
this use case doesn't have to be the first Selenium program recommended for novice users to learn.
More importantly, the dynamic DOM structure and the instant search feature
have made Google homepage definitely not the easiest thing for them.
Without revealing what's under the hood, it might give newbies the false impressions that

  - Selenium projects are like some auto-generated scripts - let's copy n' paste these statements.
  - Google's products are extremely straightforward to automate - let's try automating Gmail or Youtube next.

Instead of giving a use case that could potentially cause trouble,
it might be better to find a scenario as simple as below for learning purposes.

> 1. Search `[selenium]` on StackOverflow
> 2. Find out how many questions are tagged with "selenium"

### Everything else is too difficult
{: #everything-else-is-too-difficult}

Even though Google's products are technically automatable, it requires certain amount of time and effort to achieve{% footnote 2 %}.
Learning Selenium or performing certain tasks by automating them from UI would certainly be a poor choice.

- DOM is too complex

  Google is well-known for its meaningless, minimized DOM structures.
  Not only straightforward approaches like `id`, `name` won't work well,
  but also advanced XPath/CSS selectors can merely be used because most of the things in DOM are not human readable.
  Difficulties in element locating could be really common in UI automation sometimes,
  while automating Google's products makes it inevitable.
  Strong XPath/CSS selector skills are crucial to get the job done.

  What about text-free XPaths based on position relationship, like `//div[3]/div[1]/div[3]/span[10]/a`?
  They are even worse and likely to be changed frequently by Google.
  Brittle XPaths shouldn't be used in any kind of programs in the first place anyway.

- Some are Ajax powered

  Dynamic content handling techniques like waiting system `WebDriverWait` are essential for UI automation,
  but Ajax powered Google products (Google Maps, Youtube, etc.) would be definitely considered as one of the hardest.
  For those JavaScript and Ajax heavy applications,
  wait time might vary and debugging them are difficult due to other constraints, like dynamic DOM structures.

- DOM changes too frequently

  Just like many other active-developing web applications,
  the DOM of Google's products are constantly changed either deliberately in order to prevent scripting or as part of the development process.
  Assuming best-available locators have been used,
  it may still frequently break the existing Selenium code and make it highly unmaintainable,

- Source code is unavailable

  Having both read and write access to internal issue tracker,
  source code, documentation, private APIs can be extremely useful during UI automation process.
  On one hand, modifying source code for testing purpose, like adding class names, is a common practice for making elements locating easier.
  On the other hand, monitoring UI related bug/feature tickets would greatly help developers track down what has been changed.
  Unfortunately, external automators outside Google won't be able to take advantage of this.

### There are APIs
{: #there-are-apis}

What if you are not only learning Selenium, but also trying to achieve something from those Google services,
for instance, to verify emails in Gmail at part of the testing process?

The answer is to use APIs or existing libraries that wraps around the APIs.
Google provides APIs for [Gmail][Gmail API], [Youtube][Youtube API],
[Drive][Google Drive API], [Maps][Google Maps API] and more{% footnote 3 %}.
This is the intended and more correct way to access data.
People who have just started UI automation might think and solve problems in a way that end users will do.
However, using Selenium doesn't mean that absolutely all actions have to be performed from UI level,
which, most of the time, would be an inefficient approach.

For example, [ruby-gmail][ruby-gmail] is a Ruby library that allows accessing emails in Gmail.
After installing the gem using `gem install ruby-gmail`, writing a program to get inbox count would be just a matter of seconds:

{% highlight ruby %}
require 'gmail'

gmail = Gmail.new('GMAIL_ADDRESS', 'GMAIL_PASSWORD')
puts "Inbox count: #{gmail.inbox.count}"
{% endhighlight %}

### It was against the "Term of service"
{: #it-was-against-the-term-of-service}

Although this might no longer be true for Google applications{% footnote 4 %} and nobody really cares about user agreement,
it's still worth noting that Google specifically had statement regarding automated access in their old versions
of "[Term of Service](http://www.google.com/intl/en/policies/terms/archive/20070416-20120301/)".
Same happens to Youtube as well, which still exists in current Youtube [Terms of Service 4-H](https://www.youtube.com/static?template=terms).
<a class="show-hidden">{{ site.translations.show }}</a>

{% hide %}

<p>Google</p>
<blockquote>
5.3 You agree not to access (or attempt to access) any of the Services by any means other than through the interface that is provided by Google, unless you have been specifically allowed to do so in a separate agreement with Google. You specifically agree not to access (or attempt to access) any of the Services through any automated means (including use of scripts or web crawlers) and shall ensure that you comply with the instructions set out in any robots.txt file present on the Services.
</blockquote>

<p>Youtube</p>
<blockquote>
You agree not to use or launch any automated system, including without limitation, "robots," "spiders," or "offline readers," that accesses the Service in a manner that sends more request messages to the YouTube servers in a given period of time than a human can reasonably produce in the same period by using a conventional on-line web browser. Notwithstanding the foregoing, YouTube grants the operators of public search engines permission to use spiders to copy materials from the site for the sole purpose of and solely to the extent necessary for creating publicly available searchable indices of the materials, but not caches or archives of such materials. YouTube reserves the right to revoke these exceptions either generally or in specific cases. You agree not to collect or harvest any personally identifiable information, including account names, from the Service, nor to use the communication systems provided by the Service (e.g., comments, email) for any commercial solicitation purposes. You agree not to solicit, for commercial purposes, any users of the Service with respect to their Content.
</blockquote>

{% endhide %}

## Who might still do it?
{: #who-might-still-do-it}

- UI automation team within Google

  If such team exists, the biggest advantage for them is the accessibility to source code.
  With ability to modify source code, UI automation can be a lot easier without fighting against nasty DOM structure.
  Additionally, they can easily track down which feature/bug ticket has changed DOM structure that causing previous Selenium WebDriver code failing.
  On the other hand, instead of automating from UI level, they might also use something at lower levels,
  like private APIs to interact with certain front-end functionalities.

- People with no other choice

  Sometimes accessing from UI might be the only way to achieve a task that must be done.
  If Google doesn't provide API for a particular product and it's so important that must be done, then just do it from UI level.
  The project might be extremely difficult to implement and can be super fragile to maintain, but it should still be achievable.
  However, from my experience, I can't think of any valid use cases for this.

## What should you automate then?
{: #what-should-you-automate-then}

### Your own (or your company's) applications
{: #your-own-applications}

  Don't procrastinate.
  Instead of spending time poking around and looking for something easy enough,
  it is probably better to start from what you are supposed to do right away.
  While coding up the project gradually, many questions might be asked by yourself:

>  + How can I find elements with dynamic ID?
>  + How can I find elements with absolutely nothing identifiable?
>  + How can I avoid unnecessary waiting?
>  + How can I create more generic expected conditions?
>  + How can I DRY up my code?
>  + How can I make my classes more extensible?
>  + How can I abstract my pages?
>  + How can I ...

  As time goes by, you will be more familiar with Selenium API and the quality of the project will be improving automatically,
  as long as you are keen on getting the answers to those questions and willing to ask more.

  Additionally, creating own demos could also be a good alternative for learning Selenium.
  For example, ["The Internet"][The Internet] is a demo application written for a similar purpose,
  which provides lots of examples for common web functionalities, like hovering, frames, JavaScript alerts, etc.

### Demos of JavaScript UI frameworks
{: #demos-of-javascript-ui-frameworks}

There are common JavaScript frameworks for building web user interface, like [Ext JS][Ext JS], [Dojo Toolkit][Dojo Toolkit] and [qooxdoo][qooxdoo].
They provide heaps of interesting demos on their websites which can be used for learning Selenium WebDriver.
More importantly, you can download and create your own playground to have a better understanding of how DOM is generated and structured.
To start with, even writing some code to automate their homepage would be fun, like navigating, searching, etc.

## Further reading
{: #further-reading}

+ StackOverflow
  - [Selenium - C# - Webdriver - Unable to find element](http://stackoverflow.com/questions/23084078/selenium-c-sharp-webdriver-unable-to-find-element#comment35284360_23084078) (Arran)
  - [Webdriver to open a mail in Gmail](http://stackoverflow.com/a/8394306/1177636) (nilesh)
+ Selenium Users Group
  - [How can i start automate the google map using selenium webdriver ?](https://groups.google.com/d/msg/selenium-users/Yd-OLaFxgCU/rE4-OWxVufYJ) (Mike Riley)
  - [Stop trying to automate GMail](https://groups.google.com/d/msg/selenium-users/8jR6Fw5ndxU/7peVDuzkNN4J) (Jim Evans)
  - [Unable to handle the elements after login to gmail acount](https://groups.google.com/d/msg/selenium-users/RfNvNAbLyLs/5-SJ5dmoELMJ) (Arran)
  - [Selenium IDE & try to record Gmail login test case](https://groups.google.com/d/msg/selenium-users/aT465o3OEfQ/NT4LDgzj-YUJ)  (Krishnan)

{% footnotes %}
<p id="footnote-1">[1]: <a href="http://docs.seleniumhq.org/">"What is Selenium?"</a> section.
{% reverse_footnote 1 %}
</p>
<p id="footnote-2">[2]: Comment about Gmail <a href="http://stackoverflow.com/questions/13472062/can-we-use-web-driver-to-test-https-sites-i-am-trying-to-work-on-gmail-com-a#comment18552229_13472062">here</a> made by Ross Patterson.
{% reverse_footnote 2 %}
</p>
<p id="footnote-3">[3]: <a href="https://developers.google.com/products/">Products — Google Developers</a>
{% reverse_footnote 3 %}
</p>
<p id="footnote-4">[4]: Current version of <a href="http://www.google.com/intl/en/policies/terms/">Google Terms of Service</a>.
{% reverse_footnote 4 %}
</p>
<p id="footnote-5">[5]: Relationships between different versions of Selenium<a href="http://yizeng.me/2014/04/25/relationships-between-different-versions-of-selenium/#webdriver">#WebDriver</a>.
{% reverse_footnote 5 %}
</p>
{% endfootnotes %}

[Gmail API]: https://developers.google.com/gmail/
[Youtube API]: https://developers.google.com/youtube/
[Google Drive API]: https://developers.google.com/drive/
[Google Maps API]: https://developers.google.com/maps/
[Ext JS]: http://www.sencha.com/products/extjs/
[Dojo Toolkit]: http://dojotoolkit.org/
[qooxdoo]: http://qooxdoo.org/
[ruby-gmail]: https://github.com/dcparker/ruby-gmail
[The Internet]: http://the-internet.herokuapp.com/
