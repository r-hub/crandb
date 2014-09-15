
# How to mirror CRANDB locally

## Basics

You will need an [Apache CouchDB](http://couchdb.apache.org/) installation
to mirror CRANDB locally. The server that runs CouchDB is created by packer,
and the packer template is included in the
[Cranny project](https://github.com/metacran/cranny). In particular,
CouchDB is installed and configured with a
[provisioner script](https://github.com/metacran/cranny/blob/master/db.rpkg.org/script/couchdb.sh).

## Rewriting

We use [CouchDB vhosts](http://wiki.apache.org/couchdb/Virtual_Hosts) and
[URL rewriting](http://docs.couchdb.org/en/latest/api/ddoc/rewrites.html)
to provide a nice clean http API.

Unfortunately this makes mirroring a little more difficult, because
for (pull) mirroring to work, the slave should have access to the raw
URLs, without rewriting. The trick is to use the IP address of the master
for the pull, because URL rewriting only happens on the hostname,
but not on the IP address.

## Putting it together

1. Install CouchDB.
2. Add an admin user.
3. Bind to 0.0.0.0.
4. Create the vhost.
5. Forward port 80 to 5984, with `iptables`, or `nginx`, or whatever you
   like (optional).
6. Create a replication from CRANDB to the new server. The CRANDB URL
   should be http://107.170.56.25/cran. This should be a continuous
   replication. It is the easiest to create this from Futon or Fauxton.
   Obviously, the name of the new replicated database should be `cran`.

   

