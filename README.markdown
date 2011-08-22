# Gibbon Export

Gibbon Exportis a simple API wrapper for interacting with [MailChimp API](http://apidocs.mailchimp.com/export/)) 1.0.

###DISCLAIMER

This gem should properly be some kind of fix or new method to the original gem, I just don't have time for it :/

##Installation

    gem "gibbon_export", :git => "git://github.com/pgericson/gibbon_export.git"

##Requirements

A MailChimp account and API key. You can see your API keys [here](http://admin.mailchimp.com/account/api).

##Usage

Create an instance of the API wrapper:

    gb = GibbonExport::API.new(api_key, list_id)

There is only ONE method, its a list method to retrive all mails from a list. Get the list ids with the Gibbon gem and do `gb.GibbonExport::API.new(apikey, list_id)` to retrieve a list.

Check the API [documentation](http://apidocs.mailchimp.com/export/) for details.

##Differences from Gibbon

This gem does not use a timeout options because its can be big lists and you don't want it to timeout in the middle of downloading a list.

### Notes

If you want an even more awesome gem for mailchimp. Use [Gibbon](https://github.com/amro/gibbon) the original gem, this gem is based entirely on Gibbon so all credit goes to the author and contributors of the original gem!

##Copyrights

* Copyright (c) 2010 Amro Mousa. See LICENSE.txt for details.
* MailChimp (c) 2001-2010 The Rocket Science Group.
