---
layout: post
title: "Work with MailChimp API 3.0's pagination"
description: "Code examples for how to work with pagination in MailChimp API 3.0.
For example, get the first 500 items (i.e. more than the default value 10) at once, or ignore the first 10 entries."
categories: [tutorials]
tags: [api, c#, mailchimp]
redirect_from:
  - /2016/04/30/
---
MailChimp API 3.0 is a RESTful solution to allow applications
take action on MailChimp resources (e.g. “subscribers”, “campaigns”, "lists" etc.)
using the standard HTTP methods: POST, GET, PATCH, and DELETE.

Within this API, pagination is enabled by default for some resources,
which means HTTP GET calls only return the top 10 entries starting from the first item.
For example, using HTTP GET against `https://usX.api.mailchimp.com/3.0/lists` will only get the first 10 lists.
In order to get more than 10 items or start from a particular item,
count and offset parameters need to be applied when calling HTTP GET.

For example, in order to get more than 10 lists (e.g. get 500 lists at once),
append the `count=500` to the uri like this:

> https://us10.api.mailchimp.com/3.0/lists?count=500


In order to get items from the 11th entry and ignore the first 10 items,
append the `offset=10` to the uri as query string like this:

> https://us10.api.mailchimp.com/3.0/lists?offset=10

A real world scenario to work with pagination is that, previously at some point,
MailChimp API 3.0 couldn't handle HTTP GET request that gets more than 1000 list members at one go
(If there are thousands of members within a list,
calling HTTP GET to that list would result in HTTP 500 Internal Server Error from MailChimp server).
Therefore all list members had to be retrieved by multiple batches,
where `count` and `offset` parameters were used to solve this problem.

{% highlight c# %}
/// <summary>
/// A simple object that holds a list of deserialized MailChimp List Members.
/// </summary>
public class ListMembers
{
    public List<ListMember> members { get; set; }
}

/// <summary>
/// A simple object that holds a single deserialized MailChimp List Member.
/// </summary>
public class ListMember
{
    public string email_address { get; set; }
}

private ListMembers GetListMembers(string dataCenter, string apiKey, string listId)
{
    var result = new ListMembers { members = new List<ListMember>() };

    long offset = 0;
    const int numberPerBatch = 500; // count parameter.

    var uri = string.Format("https://{0}.api.mailchimp.com/3.0/lists/{1}/members?offset={2}&count={3}",
        dataCenter, listId, offset, numberPerBatch);

    try
    {
        while (true)
        {
            using (var webClient = new WebClient())
            {
                webClient.Headers.Add("Accept", "application/json");
                webClient.Headers.Add("Authorization", "apikey " + apiKey);

                var responseJson = webClient.DownloadString(uri);
                var responseListMembers = JsonConvert.DeserializeObject<ListMembers>(responseJson);

                if (responseListMembers.members != null)
                {
                    // Add members returned from current batch into result list.
                    result.members.AddRange(responseListMembers.members);
                }

                // When the number of members returned in this batch is less than batch size,
                // break out of the loop, as it means this is the last batch.
                if (responseListMembers.members.Count < numberPerBatch)
                {
                    break;
                }
            }
            offset += (long) numberPerBatch;
        }
        return result;
    }
    catch (WebException we)
    {
        using (var sr = new StreamReader(we.Response.GetResponseStream()))
        {
            Console.WriteLine(sr.ReadToEnd());
            throw;
        }
    }
}
{% endhighlight %}
