---
layout: post
title: "Use two different Pace.js progress bars on the same page"
description: "A demo on how to use two different Pace.js progress bars on the same page."
categories: [tutorials]
tags: [javascript]
redirect_from:
  - /2017/04/15/
---
I came across this problem while working on my little side project [Strafforts][Strafforts]
(A Visualizer for Strava Estimated Best Efforts and Races),
that how to have two different [Pace.js][Pace.js] progress bars on the same page within a single page application.

One progress bar is a global overlay that hides the entire application until the page is loaded,
while the other is a default progress bar when any Ajax is triggered without hiding any content.

After some Googling, I found [this answer](https://github.com/HubSpot/pace/issues/135) works like a charm.
Hence I'm turning it into a simple working demo for anyone is interested.

* Kramdown table of contents
{:toc .toc}

## Demo

<iframe src="/assets/demo/2017-04-15-use-two-different-pacejs-progress-bars-on-the-same-page.html"></iframe>

## Add first progress bar

First, add an ordinary Pace.js progress bar like usual.

- Add references to `pace.min.js` and the theme CSS file.

{% highlight html %}
<head>
    ...
    <script src="pace.min.js"></script>
    <link href="center-atom.css" rel="stylesheet" />
</head>
{% endhighlight %}

- Optionally, I want this one to be used as a global overlay,
which means nothing but this progress bar is shown before page has fully loaded.

{% highlight html %}
<head>
    ...
    <style>
        body> :not(.pace),
        body:before,
        body:after {
            -webkit-transition: opacity .4s ease-in-out;
            -moz-transition: opacity .4s ease-in-out;
            -o-transition: opacity .4s ease-in-out;
            -ms-transition: opacity .4s ease-in-out;
            transition: opacity .4s ease-in-out
        }
        
        body:not(.pace-done)> :not(.pace),
        body:not(.pace-done):before,
        body:not(.pace-done):after {
            opacity: 0
        }
    </style>
</head>
{% endhighlight %}

## Add second progress bar

Next step is to add another progress bar that will be shown inside application only,
when there are Ajax calls, state changes, etc.

{% highlight html %}
<head>
    <script src="pace.min.js"></script>
    <link href="center-atom.css" rel="stylesheet" />
    <link href="minimal.css" rel="stylesheet" /><!-- Add reference to a new Pace.js theme CSS. -->
    ...
</head>
{% endhighlight %}

## Make them working together

- Set page states

To indicate what the state the page is currently in and which progress bar should be shown,
add a class name on `body` element of the page.

For example, add `.content-loading` class to `body` in HTML markup,
which indicates the page hasn't been loaded and is in the initial state.

{% highlight html %}
...
<body class="content-loading"><!-- Add class name for initial state. -->
    <button onclick="Pace.restart()">Trigger Ajax</button>
    <button onclick="location.reload()">Reload Page</button>
</body>
{% endhighlight %}

Then add a piece of JavaScript code to set page state (`.content-loading` class on `body`) to `.content-loaded`
when Pace.js finishes page loading.
Once this is executed, the in-app progress bar will be shown from then on for Ajax calls, etc.

{% highlight html %}
<head>
    ...
    <script>
        Pace.on('hide', function () {
            document.getElementsByTagName("body")[0].classList.remove('content-loading');
            document.getElementsByTagName("body")[0].classList.add('content-loaded');
        });
    </script>
</head>
{% endhighlight %}

- Wrap themes with unique class names

Now the page has two states, one is the initial state where the first progress bar will be shown.
The other state is when page has been loaded,
the second progress bar will be shown for any Ajax calls, etc. within the application.

Therefore CSS themes need to be updated accordingly to reflect those two states.

If you are using CSS,
update all CSS rules in both themes to be under `.content-loading` or `.content-loaded`.
For example, `minimal.css` now looks like:

{% highlight scss %}
.content-loaded .pace {
    -webkit-pointer-events: none;
    pointer-events: none;
    -webkit-user-select: none;
    -moz-user-select: none;
    user-select: none;
}
.content-loaded .pace-inactive {
    display: none;
}
.content-loaded .pace .pace-progress {
    background: #29d;
    position: fixed;
    z-index: 2000;
    top: 0;
    right: 100%;
    width: 100%;
    height: 2px;
}
{% endhighlight %}

  If you are using [Sass][Sass], simply wrap themes with the class names like below:

{% highlight scss %}
// center-atom.scss file
.content-loading {
    // all theme styles.
}

// minimal.scss file
.content-loaded {
    // all theme styles.
}
{% endhighlight %}

- Update overlay styles

If global overlay style in place,
the last step is to update it for `.content-loading` state only.
So that content in the application will still be visible during Ajax calls.

{% highlight html %}
<head>
    ...
    <style>
        .content-loading> :not(.pace),
        .content-loading:before,
        .content-loading:after {
            -webkit-transition: opacity .4s ease-in-out;
            -moz-transition: opacity .4s ease-in-out;
            -o-transition: opacity .4s ease-in-out;
            -ms-transition: opacity .4s ease-in-out;
            transition: opacity .4s ease-in-out
        }
        
        .content-loading:not(.pace-done)> :not(.pace),
        .content-loading:not(.pace-done):before,
        .content-loading:not(.pace-done):after {
            opacity: 0
        }
    </style>
</head>
{% endhighlight %}

## Demo's source code

See demo's on JSFiddle [here][JSFiddle].

<script async src="//jsfiddle.net/yizeng/39oar0bw/embed/"></script>

[Strafforts]: http://www.strafforts.com/
[Pace.js]: http://github.hubspot.com/pace/docs/welcome/
[Sass]: http://sass-lang.com/
[JSFiddle]: https://jsfiddle.net/yizeng/39oar0bw/
