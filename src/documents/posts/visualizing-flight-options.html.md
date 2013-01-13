---
layout: post
title: Visualizing Flight Options
date: January 13, 2013
type: post
page: blog
---
[![Visualization of Flight Options](/images/visualization.png)](/images/visualization.png)

Few routine consumer purchases involve as great a volume of data as booking a flight. For an international trip, there can be dozens of options differing by price, duration, time-of day, connections, and carrier alliances. [ITA Software](http://www.itasoftware.com/), now part of Google, quietly introduced a [Gantt chart](http://en.wikipedia.org/wiki/Gantt_chart)-style visualization. The use of Gantt-charts for flights has since been perfected and popularized by [Hipmunk](http://www.hipmunk.com/). Hipmunk set the bar high, especially for domestic flights, by polishing the design and distilling the data to the minimum needed to book a flight.

While I like the Gantt-chart layout for domestic flights, I wondered if the information density could be higher for international flights. Rather than grouping flights by price (or a combined score, as Hipmunk does by default), I wanted similar flights to be grouped together. Prices tend to cluster at various pricepoints due to competitive pressure, but these clusters theselves can have large variance. To account for this I wanted to emphasize relative prices rather than ranked prices. Because international flights may involve unfamiliar airports, I wanted room for the city and full name of each airport. Also, because international flights can involve many time zones, I wanted the relative times in each city to be shown.

With this in mind, I set the X-axis to the time and the Y-axis to the airports. Flight options are represented as a curve travelling through the airports, with flat lines for connections. Each airport has its own time scale according to the local time-zone. The flights are colored on a linear scale from the cheapest (green) to most expensive (red). The exact details appear when the user moves their mouse over a flight, at which point the price and airlines are revealed. Because I wanted to emphasize relative price, I had to de-emphasize carriers, but flights are colored by carrier when the details are shown.

[![Visualization of Flight Options with flight Selected](/images/highlight.png)](/images/highlight.png)

Although this was created in the spirit of experimentation, the result is a [bookmarklet](http://en.wikipedia.org/wiki/Bookmarklet) that is fully usable for booking flights. The bookmarklet applys the visualization to data available on any [ITA Matrix](http://matrix.itasoftware.com/) Time bars results page.

To use the bookmarklet, drag the following button to your bookmarks toolbar (you may have to display the bookmarks toolbar from the browser menu). Then do a search on the [ITA Flight Matrix](http://matrix.itasoftware.com/), select the Time bars view, and press the button in your toolbar.

<a href="javascript:(function(){document.body.appendChild(document.createElement('script')).src='http://farevis.bitaesthetics.com/farevis.js';})();" style="
    font-weight: bold;
    background-color: rgb(233, 105, 4);
    display: block;
    width: 30%;
    text-align: center;
    color: black;
    padding: 10px;
    border-radius: 4px;
    margin-left: 20px;
">Visualize Flights!</a>

The bookmarklet works in Chrome, Firefox, and Safari. It doesn't work in Opera. It probably doesn't work in IE.

If you'd like to experiment with the visualization, [the code is available on GitHub](https://github.com/paulgb/farevis).
