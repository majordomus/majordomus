majordomus.dev
===

Backport from mail-in-a-box
---
Here is a list of issues raised over at mail-in-a-box/mailinabox that may need some care here as well:

* #291 - hide_output causing trouble when a conflict needs to be resolved by the user


Other
---

Supervisor

https://www.digitalocean.com/community/tutorials/how-to-install-and-manage-supervisor-on-ubuntu-and-debian-vps
/etc/supervisor/conf.d/

apps/cname/<rname>							-> canonical name
apps/iname/<name> 							-> internal name
apps/meta/<rname>							-> app metadata
apps/meta/<rname>/env/<key>					-> value
apps/meta/<rname>/port/<exposed port>		-> mapped port

ports/<port>								-> exposed port/rname