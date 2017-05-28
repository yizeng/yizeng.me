---
layout: post
title: "Convert speed to pace programmatically using Ruby"
description: "An example of converting speed (m/s) to pace (min/km or min/mile) programmatically using Ruby."
categories: [articles]
tags: [ruby, strava]
redirect_from:
  - /2017/02/25/
---
I came across a problem while working on my little side project [Strafforts][Strafforts]
(A Visualizer for Strava Estimated Best Efforts and Races),
that how to convert speed (`m/s` in this case) to pace (`min/km` or `min/mile`) programmatically using Ruby.

## Calculate time spend per distance (kilometre/mile)

[Strava Activity API][Strava Activity API] provides a field for athlete's average speed during this activity.
It is a float number for meters per seconds (i.e. the unit of the speed is `m/s`).

For example, if the speed is 4 meters per seconds and the target pace unit is `min/km`.
Then the first step is to find out how long does it take reach the target distance (one kilometre) with this speed.

This is simple math: `1000 / 4 = 250 (seconds)`.

If the target pace unit is `min/mile` (minutes per mile), then it's `1609.344 / 4 = 402.336 (seconds)` for one mile.

## Convert seconds to pace

The second step is to convert the total seconds used per distance into pace.
Note that time is base 60, while meter is base 10.

{% highlight ruby %}
minutes, seconds = 250.divmod(60)
puts "#{minutes}:#{seconds.round}" # Output: '4:10'
{% endhighlight %}

## Complete solution

{% highlight ruby %}
# Convert speed (m/s) to pace (min/mile or min/km) in the format of 'x:xx'
def convert_meters_per_second_to_pace(speed, unit = nil)
  if speed.nil? || speed == 0
    return ''
  end

  total_seconds = unit == 'mile' ? (1609.344 / speed) : (1000 / speed)
  minutes, seconds = total_seconds.divmod(60)
  seconds = seconds.round < 10 ? "0#{seconds.round}" : "#{seconds.round}"
  "#{minutes}:#{seconds}"
end
{% endhighlight %}

## What about speed unit is mph or km/h?

The concept will be exactly the same:

  1. Figure out the time per distance.
  2. Convert time to pace.

For example, to convert 12 km/h to pace:

> 12 km/h is 12 kilometres (7.45645 miles) per 3600 seconds.<br />
> So it's 3600 / 12 = 300 (seconds per km), 3600 / 7.45645 = 482.803 (seconds per mile).<br />
> Then use the modulo logic above to convert seconds into pace, which is 5:00 min/km or 8:03 min/mile.<br />


[Strafforts]: http://strafforts.yizeng.me
[Strava Activity API]: https://strava.github.io/api/v3/activities/
