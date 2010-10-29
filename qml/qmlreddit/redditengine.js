.pragma library

function RedditEngine() {
    this._init();
    // this works, but calling from qml doesn't
    this.linkSelected('dummy 1')
}

RedditEngine.prototype = {
    linkSelected : function(link) {
        console.log("linkSelected ", link)
        this.currentlink = link;

    },

    _init : function() {
        this.currentlink = {};
    },

    currentLink : function() {
        return this.currentlink;
    }



};

function create() {
    console.log("creating")
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
