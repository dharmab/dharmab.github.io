---
layout: post
title: The Naming of Things
categories: sysadmin
---

>"As names have power, words have power. Words can light fires in the minds of men. Words can wring tears from the hardest hearts. There are seven words that will make a person love you. There are ten words that will break a strong man's will. But a word is nothing but a painting of a fire. A name is the fire itself."

>\- Master Elodin, *The Name of the Wind* by Patrick Rothfuss

A server naming scheme should accomplish several goals:

### Human Parseable A Records
Humans should be able to determine a server's general role from the hostname and DNS A record. A common bad example are "themed" server names such as `superman.example.com`, `batman.example.com` and `deadpool.example.com`. A naming scheme like this makes it impossible to figure out what the hell a server actually *does*. It forces future admins to perform unnecessary detective work. Cute themed names should not be used. You will also have to generate a long list of names in advance to avoid slowing down the (re)provisioning process. If your environment is not virtualized and servers are constantly repurposed, you might argue that personalized names can be useful for identifying and labeling physical servers. In this case, the hostname could instead encode hardware information, or simply be a short randomly generated string that acts as a serial number for your asset management system.

A better example would be a name such as `database-1.example.com` or `application-3.example.com`. This at least encodes the general role in the hostname.

A great example might be `database-1.production.aws.example.com` and `billingapi-3.development.digitalocean.example.com`. In addition to encoding the general role in the hostname it also encodes the server's tier and location/provider in the domain. The general form of the name is `<role>-<serial>.<tier>.<datacenter or provider name>.<organization domain>.<tld>`. You can adapt it to your needs with some changes:

* If you deploy mixed software stacks, you might encode that information in hostname. For example, if you have both MSSQL and PostgreSQL databases you might have `database-mssql-1.production.aws.example.com` and `database-postgresql-1.production.aws.example.com`. If you have both CentOS and Debian servers, you might use `debian-database-1.production.example.com` and `centos-accountapp-1.production.example.com`
* If you think the names are too long, you can use abbreviations **as long as you document them**. For example, `windows2012-database-postgresql-2.production.example.com` could be shortened to `win2012-db-pgsql-2.prod.example.com` and `redhat6-customerapi-1.production.example.com` could be shortened to `rhel6-customerapi-1.prod.example.com`

### User-friendly CNAME Records

Use CNAMEs to alias easy-to-remember names to your servers. For example, `jira-1.production.aws.example.com` might have the following CNAMEs:

* `jira.example.com`: Easy to remember CNAME used by administrators and developers
* `bugs.example.com`: CNAME provided to bug reporters
* `help.example.com`: CNAME provided to helpdesk staff and end users

Don't provide the A Record to users. If you want to do a rebuild of your Jira server you can create `jira-2.production.aws.example.com`, migrate user data from `jira-1`, change the CNAMES to point to `jira-2` during off-peak hours and power off `jira-1` when the traffic moves over. With a short TTL on your CNAMEs, you just performed a zero-downtime migration.

### Migrate and Be Consistent

Pick a good naming scheme early on and stick with it. Changing a naming scheme can involve a lot of work and should not be a common occurrence. To migrate existing hosts, set the old name as a CNAME and notify effected parties that the old name will be deprecated. On the deprecation date, change the CNAME to point to a redirect to the new friendly CNAME (e.g. HTTP 301). Check the logs on that redirect for a reasonable period of time. If the redirect is still regularly used, contact the responsible parties. For high-availability services, consider leaving the redirect up permanently.

Once the environment is migrated, remain consistent. An inconsistent naming scheme can cause frustration and additional detective work. Document the naming policy and enforce it on your team.

### Don't Trust the Hostname

Hostnames should not be trusted as a source of truth. A server which says it's `ubuntu-wordpress-6.testing.example.com` might have an FTP server or some forgotten cron jobs as well. Names are written by people (or scripts written by people) and people lie. Use a tool to check for installed packages, running services and the presence of any interesting or large files. [Ansible Facts](http://docs.ansible.com/ansible/playbooks_variables.html#information-discovered-from-systems-facts) and [Salt Grains](http://docs.saltstack.com/en/latest/topics/targeting/grains.html) are examples of tools that can automate this detective work.

Avoid using hostnames as parseable input for automation tools/scripts. Imagine you have a script that checks the hostname of a server. If it contains `application`, it installs Tomcat and adds itself to your continuous integration environment. If it contains `database`, it installs MySQL and adds itself to your database cluster. An attacker gains control of `application-8.production.aws.amazon.com` via a 0-day vulnerability. The attacker has inside knowledge of your script and changes the hostname to `database-4.production.aws.amazon.com`. You run your script (which you also use to install updates). The compromised host now gains access to the production database and the attacker now has your customer information.

Instead, use an asset management or configuration management system as the source of truth. In Ansible this would be the [Inventory](http://docs.ansible.com/ansible/intro_inventory.html) and in Salt this would be the [Topfile](http://docs.saltstack.com/en/latest/ref/states/top.html). If you use a cloud provider, they may offer an inventory system and API you can use.

