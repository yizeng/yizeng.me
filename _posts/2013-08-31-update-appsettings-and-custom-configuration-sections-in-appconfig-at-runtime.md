---
layout: post
title: "Update AppSettings and custom configuration sections in App.config at runtime"
description: "How to update (add, edit or remove) AppSettings
and custom config sections in App.config at runtime."
categories: [articles, popular]
tags: [c#, .net]
alias: [/2013/08/31/]
utilities: highlight
---
This post shows how to update (add, edit or remove) `AppSettings`
and custom config sections in `App.config` at runtime.

* Kramdown table of contents
{:toc .toc}

## App.config file
{: #app-config-file}

Sample `App.config` file:

{% highlight xml %}
﻿﻿<?xml version="1.0" encoding="utf-8" ?>
<configuration>
    <configSections>
        <sectionGroup name="geoSettings">
            <section name="summary" type="System.Configuration.NameValueSectionHandler" />
        </sectionGroup>
    </configSections>

    <appSettings>
        <add key="Language" value="Ruby" />
        <add key="Version" value="1.9.3" />
    </appSettings>

    <geoSettings>
        <summary>
            <add key="Country" value="New Zealand" />
            <add key="City" value="Christchurch" />
        </summary>
    </geoSettings>
</configuration>
{% endhighlight %}

## Update AppSettings
{: #update-appsettings}

### Add a new key
{: #appsettings-add-a-new-key}

{% prettify c# %}
var config = ConfigurationManager.OpenExeConfiguration(ConfigurationUserLevel.None);
config.AppSettings.Settings.Add("OS", "Linux");
config.Save(ConfigurationSaveMode.Modified);

ConfigurationManager.RefreshSection("appSettings");
{% endprettify %}

### Edit an existing key's value
{: #appsettings-edit-an-existing-keys-value}

{% prettify c# %}
var config = ConfigurationManager.OpenExeConfiguration(ConfigurationUserLevel.None);
config.AppSettings.Settings["Version"].Value = "2.0.0";
config.Save(ConfigurationSaveMode.Modified);

ConfigurationManager.RefreshSection("appSettings");
{% endprettify %}

### Delete an existing key
{: #appsettings-delete-an-existing-key}

{% prettify c# %}
var config = ConfigurationManager.OpenExeConfiguration(ConfigurationUserLevel.None);
config.AppSettings.Settings.Remove("Version");
config.Save(ConfigurationSaveMode.Modified);

ConfigurationManager.RefreshSection("appSettings");
{% endprettify %}

## Update custom configuration sections
{: #update-custom-configuration-sections}

### Add a new key
{: #custom-sections-add-a-new-key}

{% prettify c# %}
var xmlDoc = new XmlDocument();
xmlDoc.Load(AppDomain.CurrentDomain.SetupInformation.ConfigurationFile);

// create new node <add key="Region" value="Canterbury" />
var nodeRegion = xmlDoc.CreateElement("add");
nodeRegion.SetAttribute("key", "Region");
nodeRegion.SetAttribute("value", "Canterbury");

xmlDoc.SelectSingleNode("//geoSettings/summary").AppendChild(nodeRegion);
xmlDoc.Save(AppDomain.CurrentDomain.SetupInformation.ConfigurationFile);

ConfigurationManager.RefreshSection("geoSettings/summary");
{% endprettify %}

### Edit an existing key's value
{: #custom-sections-edit-an-existing-keys-value}

{% prettify c# %}
var xmlDoc = new XmlDocument();
xmlDoc.Load(AppDomain.CurrentDomain.SetupInformation.ConfigurationFile);

xmlDoc.SelectSingleNode("//geoSettings/summary/add[@key='Country']").Attributes["value"].Value = "Old Zeeland";
xmlDoc.Save(AppDomain.CurrentDomain.SetupInformation.ConfigurationFile);

ConfigurationManager.RefreshSection("geoSettings/summary");
{% endprettify %}

### Delete an existing key
{: #custom-sections-delete-an-existing-key}

{% prettify c# %}
var xmlDoc = new XmlDocument();
xmlDoc.Load(AppDomain.CurrentDomain.SetupInformation.ConfigurationFile);

XmlNode nodeCity = xmlDoc.SelectSingleNode("//geoSettings/summary/add[@key='City']");
nodeCity.ParentNode.RemoveChild(nodeCity);

xmlDoc.Save(AppDomain.CurrentDomain.SetupInformation.ConfigurationFile);
ConfigurationManager.RefreshSection("geoSettings/summary");
{% endprettify %}

## Print out all keys
{: #print-out-all-keys}

{% prettify c# %}
var appSettings = ConfigurationManager.AppSettings;
var customSettings = ConfigurationManager.GetSection("geoSettings/summary") as NameValueCollection;

foreach (string key in appSettings.AllKeys) {
    Console.WriteLine("{0}: {1}", key, appSettings[key]);
}
foreach (string key in customSettings.AllKeys) {
    Console.WriteLine("{0}: {1}", key, customSettings[key]);
}
{% endprettify %}

## References
{: #references}

1. [Modifying app.config at runtime throws exception](http://stackoverflow.com/q/8807218/1177636)
2. [update app.config file programatically with ConfigurationManager.OpenExeConfiguration(ConfigurationUserLevel.None);](http://stackoverflow.com/q/8522912/1177636)
3. [Opening the machine/base Web.Config (64bit) through code](http://stackoverflow.com/q/8130085/1177636)