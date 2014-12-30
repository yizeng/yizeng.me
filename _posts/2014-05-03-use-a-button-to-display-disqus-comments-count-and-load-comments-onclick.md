---
layout: post
title: "Use a button to display Disqus comments count and load comments onClick"
description: "How to create a button to display Disqus comments count and load comments onClick event."
categories: [notes, popular]
tags: [disqus, javascript]
alias: [/2014/05/03/]
utilities: highlight, show-hidden
---
Considering most of the site visitors don't read comments,
within those who read comments, only few of them would actually say something,
it might be a good idea to avoid loading Disqus comments by default.
Since Disqus makes enormous amount of requests during creation,
disabling it will increase page's loading speed slightly.

Therefore here is a note on
how to create a "Show Comments" button to load Disqus comments `onClick` event.
To improve user experience,
the comments count will be pulled using Disqus API and displayed right in this button.

* Kramdown table of contents
{:toc .toc}

## Demo
{: #demo}

<iframe src="/assets/demo/2014-05-03-disqus-comments-button.html"></iframe>

## HTML markup
{: #html-markup}

{% highlight html %}
<button class="show-comments" data-disqus-url="REPLACE_WITH_DISQUS_THREAD_URL">Show Comments</button>
<div id="disqus_thread"></div>
{% endhighlight %}

**Notes**:

1. Inside `<button>` element, `data-disqus-url` attribute will be used for polling Disqus comments count using its API.
2. `<div id="disqus_thread"></div>` is a placeholder which will be used by Disqus to create comments area.

## Show Disqus comments count
{: #show-disqus-comments-count}

Disqus provides [count.js][count.js] officially for generating comments count links, which only has limited functionalities.
Luckily, Disqus API also allows getting comments in a more flexible way.
A detailed official tutorial "Get comment counts with the API" can be found [here][Comments count tutorial].

{% highlight javascript %}
var disqusPublicKey = "REPLACE_WITH_DISQUS_PUBLIC_KEY";
var disqusShortname = "REPLACE_WITH_DISQUS_SHORTNAME";
var threadUrl = 'link:' + $('.show-comments').attr('data-disqus-url');

$.ajax({
    type: 'GET',
    url: 'https://disqus.com/api/3.0/threads/set.jsonp',
    data: { api_key: disqusPublicKey, forum: disqusShortname, thread: threadUrl },
    cache: false,
    dataType: 'jsonp',
    success: function(result) {
        if (result.response.length === 1) {
            btnText = 'Show Comments (' + result.response[0].posts + ')';
            $('.show-comments').html(btnText);
        }
    }
});
{% endhighlight %}

**Notes**:

1. Register a [Disqus API key][Disqus API register] first, where only the public key will be needed here.
2. Use Disqus API's [threads/set][threads/set] method, which takes in Disqus shortname, public key and thread URL.
3. The quota for API calls is 1000 per hour.
   If expected requests are larger than that, please contact Disqus support team to increase the limit{% footnote 1 %}.

## Load Disqus comments onClick
{: #load-disqus-comments-onclick}

The actual Disqus comments can be loaded by calling its `embed.js`,
either using traditional JavaScript approach like [this][Universal Code] or jQuery approach like below{% footnote 2 %}.

{% highlight javascript %}
$('.show-comments').on('click', function() {
    $.ajaxSetup({cache:true});
    $.getScript('http://' + disqusShortname + '.disqus.com/embed.js');
    $.ajaxSetup({cache:false});
    $(this).remove();
});
{% endhighlight %}


## Load comments if URL contains \#comment
{: #load-comments-if-url-contains-comment}

If someone enters the page directly targeting to Disqus comments,
then comments should be loaded automatically.
To do so, trigger click action if `#comment` is part of the in coming URL.

{% highlight javascript %}
if(/\#comment/.test(location.hash)){
    $('.show-comments').trigger('click');
}
{% endhighlight %}

## Full example
{: #full-example}

<a class="show-hidden">{{ site.translations.show }}</a>

{% hide %}
{% highlight javascript %}
$(document).ready(function () {
    var disqusPublicKey = "REPLACE_WITH_DISQUS_PUBLIC_KEY";
    var disqusShortname = "REPLACE_WITH_DISQUS_SHORTNAME";
    var threadUrl = 'link:' + $('.show-comments').attr('data-disqus-url');

    $.ajax({
        type: 'GET',
        url: 'https://disqus.com/api/3.0/threads/set.jsonp',
        data: { api_key: disqusPublicKey, forum: disqusShortname, thread: threadUrl },
        cache: false,
        dataType: 'jsonp',
        success: function(result) {
            if (result.response.length === 1) {
                btnText = 'Show Comments (' + result.response[0].posts + ')';
                $('.show-comments').html(btnText);
            }
        }
    });

    $('.show-comments').on('click', function() {
        $.ajaxSetup({cache:true});
        $.getScript('http://' + disqusShortname + '.disqus.com/embed.js');
        $.ajaxSetup({cache:false});
        $(this).remove();
    });

    if(/\#comment/.test(location.hash)){
        $('.show-comments').trigger('click');
    }
});
{% endhighlight %}
{% endhide %}

## Disadvantage
{: #disadvantage}

[Googlebot][Googlebot] won't be able to index those comments anymore.

{% footnotes %}
<p id="footnote-1">[1]: StackOverflow answer made
<a href="http://stackoverflow.com/a/16350173/1177636">here</a> by Ryan V.
{% reverse_footnote 1 %}
</p>
<p id="footnote-2">[2]:
<a href="http://blog.yjl.im/2012/04/let-your-readers-decide-when-to-load.html">Let your readers decide when to load Disqus</a> by Yu-Jie Lin.
{% reverse_footnote 2 %}
</p>
{% endfootnotes %}

[count.js]: http://help.disqus.com/customer/portal/articles/565624-tightening-your-disqus-integration
[Comments count tutorial]: http://help.disqus.com/customer/portal/articles/1131783-tutorial-get-comment-counts-with-the-api
[threads/set]: https://disqus.com/api/docs/threads/set/
[Disqus API register]: https://disqus.com/api/applications/
[Universal Code]: https://yizeng-cn.disqus.com/admin/universalcode/
[Googlebot]: https://support.google.com/webmasters/answer/182072?hl=en
