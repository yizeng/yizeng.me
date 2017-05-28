if (!navigator.userAgent.match(/.*(Pingdom|PhantomJS|bot|StatusCake).*/gi)) {
    (function(i, s, o, g, r, a, m) {
        i['GoogleAnalyticsObject'] = r;
        i[r] = i[r] || function() {
            (i[r].q = i[r].q || []).push(arguments)
        }, i[r].l = 1 * new Date();
        a = s.createElement(o),
            m = s.getElementsByTagName(o)[0];
        a.async = 1;
        a.src = g;
        m.parentNode.insertBefore(a, m)
    })(window, document, 'script', '//www.google-analytics.com/analytics.js', 'ga');

    ga('create', 'UA-42466615-1', 'auto');
    ga('send', 'pageview');
}

// Google Analytics event tracking common functions.
function sendGaEvent(category, action, label) {
    if (typeof label === 'undefined') {
        ga('send', {
            hitType: 'event',
            eventCategory: category,
            eventAction: action
        });
    } else {
        ga('send', {
            hitType: 'event',
            eventCategory: category,
            eventAction: action,
            eventLabel: label.trim()
        });
    };
};

function handleOutboundLinkClicks(href) {
    ga('send', 'event', {
        eventCategory: 'Outbound Link',
        eventAction: 'Click',
        eventLabel: href.trim(),
        transport: 'beacon'
    });
}

$('.external').on('click', function() {
    handleOutboundLinkClicks($(this).attr('href'));
});
$('.btn-circle.page-scroll').on('click', function() {
    sendGaEvent('Home', 'Scroll Down');
});
$('.navbar-brand, .navbar-nav a, .navbar-brand.page-scroll').on('click', function() {
    sendGaEvent('Home', 'Navigate', this.textContent);
});
$('#blog .btn').on('click', function() {
    sendGaEvent('Home', 'Visit My Blog');
});
