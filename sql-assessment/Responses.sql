/*
AUTHOR: Paul Hwang
*/


# 1. Write a query to get the sum of impressions by day.

select Date(date) as day, SUM(impressions) as total_day_impressions
from marketing_data
group by day
order by day;


# 2. Write a query to get the top three revenue-generating states in order of best to worst. How much revenue did the third best state generate?

/*
The third best state generated 37577. The units are unknown, so we will assume $37577.
*/

select state, SUM(revenue) as total_revenue
from website_revenue
group by state
order by total_revenue DESC
limit 3;

# 3. Write a query that shows total cost, impressions, clicks, and revenue of each campaign. Make sure to include the campaign name in the output.

select ci.name, SUM(md.cost) as total_cost, SUM(md.impressions) as total_impressions, SUM(md.clicks) as total_clicks, SUM(wr.revenue) as total_revenue
from campaign_info ci
left join marketing_data md on ci.id = md.campaign_id
left join website_revenue wr on ci.id = wr.campaign_id
group by ci.id, ci.name
order by ci.name;

# 4. Write a query to get the number of conversions of Campaign5 by state. Which state generated the most conversions for this campaign?

/*
Georgia generated the most conversions for campaign 5.
*/

select ci.name, wr.state, SUM(md.conversions) as total_conversion
from campaign_info ci
left join marketing_data md on ci.id = md.campaign_id
left join website_revenue wr on ci.id = wr.campaign_id
where ci.name = 'Campaign5'
group by ci.name, wr.state
order by total_conversion desc;

# 5. In your opinion, which campaign was the most efficient, and why?

/*
In my opinion, campaign 4 was the most efficient campaign.

First thing I should do is talk to the team to figure out what each variables are and how important selected variables are.
However, since I cannot talk to the team, I will simply use ratio of cost to other variables to determine efficiency.

Looking at the ratios from the query above, we can find that campaign 4 has the highest cost to impression ratio, 
cost to revenue ratio, and cost to conversion ratio. For cost to clicks ratio, the campaign4 has second highest
cost to clicks ratio, which makes campaign 4 the most efficient out of all the campaigns as it has the highest ratios in
majority of cases.

One caveat is that the data collected is very small, with 30 entries total. Hence, with the collected information, I can
say that the campaign 4 is most efficient, but it must be noted that there may not be enough data and we may want to collect
more for higher accuracy.
*/

select ci.name, SUM(md.cost) as total_cost, SUM(md.impressions) as total_impressions, SUM(md.conversions) as total_conversions,
SUM(md.clicks) as total_clicks, SUM(wr.revenue) as total_revenue,
SUM(md.impressions) / SUM(md.cost) as cost_impression_ratio, 
SUM(md.clicks) / SUM(md.cost) as cost_clicks_ratio, 
SUM(wr.revenue) / SUM(md.cost) as cost_revenue_ratio,
SUM(md.conversions) / SUM(md.cost) as cost_conversion_ratio
from campaign_info ci
left join marketing_data md on ci.id = md.campaign_id
left join website_revenue wr on ci.id = wr.campaign_id
group by ci.id, ci.name
order by ci.name;

# Bonus: 6. Write a query that showcases the best day of the week (e.g., Sunday, Monday, Tuesday, etc.) to run ads.

/*
I have chosen Sunday as the best day of the week to run ads.

However, one thing to note is that there are different ways to define "the best day of the week to run ads." I have used average revenue
as a metric since the point of the ads are to generate revenue. This is easy to do and easy to show in a single line.

However, the team doing the research may be interested in other factors as well. For example, impressions and clicks are measures of
how much the ads have been exposed, and if the team values not only the revenue generated but also the exposure which can lead to 
future revenue, there will have to be additional transformations and other works done to combine all of the factors into a single 
metric for the best day of the week to run ads.

To conclude, I have used average revenue as a metric for the question, but it is best to talk to the team and determine relevant factors of 
the best day of the week to run ads and use the outside knowledge to answer the question fully.
*/

With wr as (
	select DAYNAME(date) as day_of_the_week, COUNT(date) as counts,
    SUM(revenue) as total_revenue, AVG(revenue) as avg_revenue
    from website_revenue
    group by day_of_the_week
), md as (
	select DAYNAME(date) as day_of_the_week, COUNT(date) as counts,
	SUM(impressions) as total_impressions, SUM(clicks) as total_clicks, SUM(conversions) as total_conversions,
	AVG(impressions) as avg_impressions, AVG(clicks) as avg_clicks, AVG(conversions) as avg_conversions
    from marketing_data
    group by day_of_the_week
)
select md.day_of_the_week, md.counts, md.total_impressions, md.total_clicks, md.total_conversions, wr.total_revenue,
md.avg_impressions, md.avg_clicks, md.avg_conversions, wr.avg_revenue
from wr join md on md.day_of_the_week = wr.day_of_the_week
order by avg_revenue desc
limit 1;


# this is query to see everything at once

With wr as (
	select DAYNAME(date) as day_of_the_week, COUNT(date) as counts,
    SUM(revenue) as total_revenue, AVG(revenue) as avg_revenue
    from website_revenue
    group by day_of_the_week
), md as (
	select DAYNAME(date) as day_of_the_week, COUNT(date) as counts,
	SUM(impressions) as total_impressions, SUM(clicks) as total_clicks, SUM(conversions) as total_conversions,
	AVG(impressions) as avg_impressions, AVG(clicks) as avg_clicks, AVG(conversions) as avg_conversions
    from marketing_data
    group by day_of_the_week
)
select md.day_of_the_week, md.counts, md.total_impressions, md.total_clicks, md.total_conversions, wr.total_revenue,
md.avg_impressions, md.avg_clicks, md.avg_conversions, wr.avg_revenue
from wr join md on md.day_of_the_week = wr.day_of_the_week
order by avg_revenue desc;

