var couchapp = require('couchapp')
, path = require('path');

// Views
// =====
//
// A view corresponds to a subset of the records, and a type of ordering,
// essentially. E.g. one can get the same final data if a view returns
// documents, and these are taken apart by the list function, or if
// the view returns each version of the package separately. But the
// ordering will be different in both cases.
//
// We have the following views:
// - packages, all package documents, ordered by package name
// - active, active (non-archived) package documents, ordered by 
//   release date
// - pkgreleases, package versions, ordered by release date
// - archivals, last package versions for archived packages,
//   ordered by archival date
// - events, package events, ordered by event date
// - releases, R releases, ordered by date
// - release, packages and their versions for each R release
// - releasedesc, packages and their versions for each R release,
//   include more data in addition to the version number
// - releasepkgs, package versions for each R release
//   include full record (for that version)
// - topdeps, number of reverse dependencies, ordered

// Lists
// =====
//
// A list is a transformation of a view, e.g. taking out one specific
// version, or specific fields. A list has an input format and an
// output format.
// 
// We have the following lists:
// - id, put rows in an dictionary, use key as key
// - id1, put rows in an dictionary, use key[1] as key
// - il, put rows in a list
// - desc, minimal description of a package version
// - latest, most recent version of the package(s)
// - top20, sort according to value and show the top 20 with key[1] as key

// API
// ===

ddoc = {
    _id: '_design/app'
    , views: {}
    , lists: {}
    , shows: {}
    , rewrites: 
    [ { from: "/", to: "../.." }
    , { from: '/-/all', to: '_list/id/active' }
    , { from: '/-/desc', to: '_list/desc/active' }
    , { from: '/-/latest', to: '_list/latest/active' }
    , { from: '/-/allall', to: '_list/id/packages' }
    , { from: '/-/pkgreleases', to: '_list/il/pkgreleases' }
    , { from: '/-/archivals', to: '_list/il/archivals' }
    , { from: '/-/events', to: '_list/il/events' }
    , { from: '/-/releases', to: '_list/il/releases' }
    , { from: '/-/releasepkgs/:version', to: '_list/id1/releasepkgs',
	query: { "start_key":[":version"],
		 "end_key":[":version",{}] } }
    , { from: '/-/release/:version', to: '_list/id1/release', 
        query: { "start_key":[":version"],
		 "end_key":[":version",{}] } }
    , { from: '/-/releasedesc/:version', to: '_list/id1/releasedesc',
        query: { "start_key":[":version"], 
		 "end_key":[":version",{}] } }
    , { from: '/-/topdeps/:version', to: '_list/top20/topdeps',
        query: { "group_level": "2", "start_key":[":version"],
		 "end_key":[":version",{}] } }
    , { from: '/-/deps/:version', to: '_list/id1/topdeps',
        query: { "group_level": "2", "start_key":[":version"],
		 "end_key":[":version",{}] } }
    , { from: '/:pkg', to: '_show/package/:pkg' }
    , { from: '/:pkg/:version', to: '_show/package/:pkg' }
    ]
};

module.exports = ddoc;

ddoc.views.packages = {
    map: function(doc) {
	if (doc.type && doc.type != "package") return
	emit(doc._id, doc)
    }
}

ddoc.views.active = { 
    map: function(doc) {
	if (doc.type && doc.type != "package") return
	if (!doc.archived) { emit(doc._id, doc); }
    }
}

ddoc.views.pkgreleases = {
    map: function(doc) {
	if (doc.type && doc.type != "package") return
	for (var t in doc.timeline) {
	    if (doc.timeline && doc.timeline[t] != "Invalid date" &&
		t != "archived") {
		emit(doc.timeline[t], 
		     { "date": doc.timeline[t], "name": doc.name,
		       "package": doc.versions[t] })
	    }
	}
    }
}

ddoc.views.events = {
    map: function(doc) {
	if (doc.type && doc.type != "package") return
	for (var t in doc.timeline) {
	    if (doc.timeline && doc.timeline[t] != "Invalid date") {
		var ev = t === "archived" ? "archived" : "released"
		var ver = t
		if (ver === "archived") ver=doc.latest		    
		emit(doc.timeline[t], 
		     { "date": doc.timeline[t], "name": doc.name, "event": ev,
		       "package": doc.versions[ver] })
	    }
	}
    }
}

ddoc.views.archivals = {
    map: function(doc) {
	if (doc.type && doc.type != "package") return
	if (doc.archived) {
	    emit(doc.timeline['archived'], 
		 { "date": doc.archived_date, "name": doc.name, 
		   "comment": doc.archived_comment, 
		   "package": doc.versions[doc.latest] })
	}
    }
}

ddoc.views.releases = {
    map: function(doc) {
	if (!doc.type || doc.type != "release") return
	emit(doc.date, { version: doc._id, date: doc.date })
    }
}

ddoc.views.release = {
    map: function(doc) {
	if (doc.type && doc.type != "package") return
	if (!doc.versions) return
	for (var i in doc.versions) {
	    var v=doc.versions[i]
	    var r=v.releases
	    for (var j in v.releases) {
		emit([r[j], doc.name], i)
	    }
	}
    }
}

ddoc.views.releasedesc = {
    map: function(doc) {
	if (doc.type && doc.type != "package") return
	if (!doc.versions) return
	for (var i in doc.versions) {
	    var v=doc.versions[i]
	    var r=v.releases
	    for (var j in v.releases) {
		emit([r[j], doc.name], { version: i, title: v.Title })
	    }
	}
    }
}

ddoc.views.releasepkgs = {
    map: function(doc) {
	if (doc.type && doc.type != "package") return
	if (!doc.versions) return
	for (var i in doc.versions) {
	    var v=doc.versions[i]
	    var r=v.releases
	    for (var j in v.releases) {
		emit([r[j], doc.name], doc.versions[i])
	    }
	}
    }
}

ddoc.views.topdeps = {
    map: function(doc) {
	if (doc.type && doc.type != "package") return
	if (!doc.versions) return
	var base=["base", "compiler", "datasets", "graphics", "grDevices",
		  "grid", "methods", "parallel", "splines", "stats",
		  "stats4", "tcltk", "utils"]
	var dep_fields = [ "Depends", "Imports", "Suggests", "Enhances",
			   "LinkingTo" ]

	for (var i in doc.versions) {
	    var ver = doc.versions[i]
	    var rels = ver.releases || []
	    if (i == doc.latest && !doc.archived) {
		rels=rels.concat("devel")
	    }
	    if (rels.length==0) continue
	    var reported=[]
	    for (var f in dep_fields) {
		var ff=dep_fields[f]
		if (ff in ver) {
		    for (var p in ver[ff]) {
			if (p != "R" && reported.indexOf(p) < 0 &&
			    base.indexOf(p) < 0) {
			    reported = reported.concat(p)
			    for (var r in rels) {
				var rel=rels[r]
				emit([rel, p, doc._id], 1)
			    }
			}
		    }
		}
	    }
	}
    },
    reduce: '_sum'
}

ddoc.lists.il = function(doc, req) {
    var row, first=true
    send('[ ')
    while (row = getRow()) {
	if (!row.id) continue
	if (first) first=false; else send(",")
	send(JSON.stringify(row.value))
    }
    send(" ]")
}

ddoc.lists.id = function(doc, req) {
    var row, first=true
    send('{ ')
    while (row = getRow()) {
	if (!row.id) continue
	if (first) first=false; else send(",")
	send(JSON.stringify(row.key) + ":" + JSON.stringify(row.value))
    }
    send(" }")
}

// NOTE: don't need to sort everything, just find the top 20
ddoc.lists.top20 = function(doc, req) {
    var row, first=true
    var data = []
    while(row = getRow()) {
	data.push(row);
    }
    data.sort(function(a, b){
	return a.value - b.value;
    }).reverse();
    send('[ ')
    for(i in data.slice(0, 20)) {
	if (first) first=false; else send(",")
	send("{ " + JSON.stringify(data[i].key[1]) + ': ' +
	     JSON.stringify(data[i].value) + " } ");
    }
    send(" ]")
}

ddoc.lists.id1 = function(doc, req) {
    var row, first=true
    send('{ ')
    while (row = getRow()) {
	if (first) first=false; else send(",")
	send(JSON.stringify(row.key[1]) + ":" + JSON.stringify(row.value))
    }
    send(" }")
}

ddoc.lists.desc = function(doc, req) {
    var row, first=true
    send('{ ')
    while (row = getRow()) {
	if (!row.id) continue
	if (first) first=false; else send(",")
	send(JSON.stringify(row.key) + ": { " +
	     "\"version\": " + JSON.stringify(row.value.latest) + ", " +
	     "\"title\": " + JSON.stringify(row.value.title) +
	     " }")
    }
    send(" }")
}

ddoc.lists.latest = function(doc, req) {
    var row, first=true
    send('{ ')
    while (row = getRow()) {
	var latest=row.value.latest
	if (!row.id) continue
	if (first) first=false; else send(",")
	send(JSON.stringify(row.key) + ": " +
	     JSON.stringify(row.value.versions[latest]))
    }
    send(" }")
}

ddoc.shows.package = function(doc, req) {

    var code = 200
      , headers = {"Content-Type":"application/json"}
      , body = null
    
    var ver = req.query.version
    if (!req.query.version) ver = doc.latest
    if (ver != "all") {
	body = doc.versions[ver]
	if (!body) {
	    code = 404
	    body = {"error" : "version not found: " + req.query.version}
	}
    } else {
	body = doc
	delete body._revisions
    }
    
    body = req.query.jsonp
	? req.query.jsonp + "(" + JSON.stringify(body) + ")"
	: toJSON(body)

    return { code : code, body : body, headers : headers }
}

ddoc.validate_doc_update = function(newDoc, oldDoc, userCtx) {
    if ((userCtx.roles.indexOf('_admin') === -1)) { 
	throw({unauthorized: 'Only admins may create/edit documents.'}); 
    }
}
