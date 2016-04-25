---
layout: post
title: "READ/CREATE MailChimp Lists and List Members using MailChimp API 3.0"
description: "Code examples for how to perform READ/CREATE (GET/POST/PUT) operations on MailChimp lists and list members using MailChimp API 3.0."
categories: [articles, popular]
tags: [c#, mailchimp]
alias: [/2016/04/23/]
utilities: highlight
---
After months of mucking around with MailChimp API 3.0 using C#, it came to my attention that there are not many examples out on the internet. Therefore this post will show some code examples on how to perform GET/POST/PUT operations on MailChimp lists and members.

* Kramdown table of contents
{:toc .toc}

## Obtain an API key
{: #obtain-an-api-key}

With MailChimp API 3.0, you can sync email activity and campaign stats with your database, manage lists, create and edit Automation workflows, and many more. It is designed for developers, engineers, or anyone else who’s comfortable creating custom-coded solutions or integrating with RESTful APIs, where you can find the API 3.0 documentation [here](http://developer.mailchimp.com/documentation/mailchimp/guides/get-started-with-mailchimp-api-3/).

To begin with, get an API key from your MailChimp account as per documentation [here](http://kb.mailchimp.com/accounts/management/about-api-keys/#Find-or-Generate-Your-API-Key). Here for example, `2ffadd1fe2293bbbc7b1c5cb3e94d89b-us10` is my MailChimp API key, where `2ffadd1fe2293bbbc7b1c5cb3e94d89b` is the actual token and `us10` is the datacenter my MailChimp uses.

## Lists
{: #lists}

### Read (GET)
{: #get-list}

MailChimp API 3.0 provides methods to read all lists or just a particular one list.

{% prettify c# %}
/// <summary>
/// If listId is empty, all lists will be retrieved.
/// </summary>
private string GetLists(string dataCenter, string apiKey, string listId = "")
{
    var uri = string.Format("https://{0}.api.mailchimp.com/3.0/lists/{1}", dataCenter, listId);
    try
    {
        using (var webClient = new WebClient())
        {
            webClient.Headers.Add("Accept", "application/json");
            webClient.Headers.Add("Authorization", "apikey " + apiKey);

            return webClient.DownloadString(uri);
        }
    }
    catch (WebException we)
    {
        using (var sr = new StreamReader(we.Response.GetResponseStream()))
        {
            return sr.ReadToEnd();
        }
    }
}
{% endprettify %}

### Create (POST)
{: #create-list}

MailChimp API 3.0 supports creating list using HTTP POST. A list of required fields can be found [here](http://developer.mailchimp.com/documentation/mailchimp/reference/lists/#create-post_lists).

{% prettify c# %}
private static string CreateList(string dataCenter, string apiKey)
{
    var sampleList = JsonConvert.SerializeObject(
        new
        {
            name = "Sample List",
            contact = new
            {
                company = "MailChimp",
                address1 = "675 Ponce De Leon Ave NE",
                address2 = "Suite 5000",
                city = "zip",
                state = "GA",
                zip = "30308",
                country = "US",
                phone = ""
            },
            permission_reminder = "You'\''re receiving this email because you signed up for updates about Freddie'\''s newest hats.",
            campaign_defaults = new
            {
                from_name = "Freddie",
                from_email = "freddie@freddiehats.com",
                subject = "MailChimp Demo",
                language = "en",
            },
            email_type_option = true
        });
    var uri = string.Format("https://{0}.api.mailchimp.com/3.0/lists", dataCenter);

    try
    {
        using (var webClient = new WebClient())
        {
            webClient.Headers.Add("Accept", "application/json");
            webClient.Headers.Add("Authorization", "apikey " + apiKey);

            return webClient.UploadString(uri, "POST", sampleList);
        }
    }
    catch (WebException we)
    {
        using (var sr = new StreamReader(we.Response.GetResponseStream()))
        {
            return sr.ReadToEnd();
        }
    }
}
{% endprettify %}

## List Members
{: #list-members}

### Read (GET)
{: #get-list-member}

Just like getting lists information using MailChimp API 3.0, list members can be retrieved in the similar fashion.
If the subscriber hash is not provided, all members within a list will be retrieved.

{% prettify c# %}
/// <summary>
/// If subscriberHash is empty, all list members within this list will be retrieved.
/// </summary>
private static string GetListMember(string dataCenter, string apiKey, string listId, string subscriberEmail = "")
{
    var hashedEmailAddress = string.IsNullOrEmpty(subscriberEmail) ? "" : CalculateMD5Hash(subscriberEmail.ToLower());
    var uri = string.Format("https://{0}.api.mailchimp.com/3.0/lists/{1}/members/{2}", dataCenter, listId, hashedEmailAddress);
    try
    {
        using (var webClient = new WebClient())
        {
            webClient.Headers.Add("Accept", "application/json");
            webClient.Headers.Add("Authorization", "apikey " + apiKey);

            return webClient.DownloadString(uri);
        }
    }
    catch (WebException we)
    {
        using (var sr = new StreamReader(we.Response.GetResponseStream()))
        {
            return sr.ReadToEnd();
        }
    }
}

private static string CalculateMD5Hash(string input)
{
    // Step 1, calculate MD5 hash from input.
    var md5 = System.Security.Cryptography.MD5.Create();
    byte[] inputBytes = System.Text.Encoding.ASCII.GetBytes(input);
    byte[] hash = md5.ComputeHash(inputBytes);

    // Step 2, convert byte array to hex string.
    var sb = new StringBuilder();
    foreach (var @byte in hash)
    {
        sb.Append(@byte.ToString("X2"));
    }
    return sb.ToString();
}
{% endprettify %}

### Create or Update (PUT)
{: #create-or-update-list-members}

MailChimp API 3.0 has standard HTTP [POST/PATCH](http://developer.mailchimp.com/documentation/mailchimp/reference/lists/members/#)
methods to create/update a list member.
In addition to that, there is also a HTTP PUT method to add or update a list member,
which I personally find it quite handy.

{% prettify c# %}
private static string AddOrUpdateListMember(string dataCenter, string apiKey, string listId, string subscriberEmail)
{
    var sampleListMember = JsonConvert.SerializeObject(
        new
        {
            email_address = subscriberEmail,
            merge_fields =
            new {
                FNAME = "Foo",
                LNAME = "Bar"
            },
            status_if_new = "subscribed"
        });

    var hashedEmailAddress = string.IsNullOrEmpty(subscriberEmail) ? "" : CalculateMD5Hash(subscriberEmail.ToLower());
    var uri = string.Format("https://{0}.api.mailchimp.com/3.0/lists/{1}/members/{2}", dataCenter, listId, hashedEmailAddress);
    try
    {
        using (var webClient = new WebClient())
        {
            webClient.Headers.Add("Accept", "application/json");
            webClient.Headers.Add("Authorization", "apikey " + apiKey);

            return webClient.UploadString(uri, "PUT", sampleListMember);
        }
    }
    catch (WebException we)
    {
        using (var sr = new StreamReader(we.Response.GetResponseStream()))
        {
            return sr.ReadToEnd();
        }
    }
}

private static string CalculateMD5Hash(string input)
{
    // Step 1, calculate MD5 hash from input.
    var md5 = System.Security.Cryptography.MD5.Create();
    byte[] inputBytes = System.Text.Encoding.ASCII.GetBytes(input);
    byte[] hash = md5.ComputeHash(inputBytes);

    // Step 2, convert byte array to hex string.
    var sb = new StringBuilder();
    foreach (var @byte in hash)
    {
        sb.Append(@byte.ToString("X2"));
    }
    return sb.ToString();
}
{% endprettify %}
