.pragma library

function RedditEngine() {
    this._init();
    // this works, but calling from qml doesn't
    this.linkSelected('dummy 1')
}

var _privs = {}
// only works will with qml objects
function priv(key) {
    var s = ""
    var h = key.toString()
    //console.log("hash",h)
    var o = _privs[key]
    if (!o) {
        o = {}
        _privs[key] = o
    }
    return o
}


function clone(obj) {
    var res = {}
    for (var i in obj) {
        res[i] = obj[i]

    }
    return res
}

RedditEngine.prototype = {
    setModels : function (mdlReddit, mdlSession) {
            this.mdlReddit = mdlReddit
            this.mdlRedditSession = mdlSession

    },

    linkSelected : function(link) {
        //console.log("linkSelected ", link)
        this.currentlink = link;

    },

    _init : function() {
        this.lcount = 0
        this.currentlink = {}
        // just to keep objects alive, not to speed up
        this.lcache = {}
        this.linkSelection = "hot"

    },

    currentLink : function() {
        return this.currentlink;
    },

    catSelected: function(cat) {
        this.currentCat = cat
        this.lcount = 0
        //this.lcache = {}
    },

    shouldShowComments : function(lnk) {
        var direct= ["comics", "pics", "fffffffuuuuuuuuuuuu"]
        var i = direct.indexOf(lnk.subreddit)
        if (i != -1)
            return false;

        if (lnk.comments < 10 ) {
            return false;
        }

        return true;

    },

    getLink : function(index) {
        var lnk = this.lcache[index]
        if (!lnk) {
            var l2 = this.mdlReddit.getLink(index)
            lnk = clone(l2)
            //console.log("cache miss ",lnk)
            this.lcache[index] = lnk
        }

        return lnk

    },

    fetchLinks : function() {
        this.mdlReddit.start(this.currentCat, "")
        this.lcache = {}
    },

    fetchMore : function() {
        this.lcache = {}
        this.lcount += 25
        this.mdlReddit.start(this.currentCat, "after=" + this.mdlReddit.lastName())

    },

    setLinkSelection : function(sel) {
        this.linkSelection = sel

    }

}



function create() {
    //console.log("creating")
    var eng = new RedditEngine();
    // this works
    eng.linkSelected("dummy 2")
    dump(eng)
    return eng
}

var _instance;

function eng() {
    if (!_instance) {
        _instance = new RedditEngine()
    }
    return _instance;

}


function dump(obj) {

    for (var i in obj ) {
        console.log("Property", i, ":", obj[i])
    }
}

function doLinkSelected(eng, link) {
    eng.linkSelected(link);
}
