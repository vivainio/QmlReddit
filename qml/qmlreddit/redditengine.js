function init() {
    console.log("hello")

}


function RedditEngine() {
    this._init();
    // this works, but calling from qml doesn't
    this.linkSelected('dummy')
}

RedditEngine.prototype = {
    linkSelected : function(link) {
        console.log("linkSelected ", link)
        this.currentlink = link;

    },

    _init : function() {
        this.currentlink = {};
    }

};

function create() {
    console.log("creating")
    var eng = new RedditEngine();
    eng.linkSelected("dummy 2")
    dump(eng)
    return eng
}

function dump(obj) {

    for (var i in obj ) {
        console.log("Property", i, ":", obj[i])
    }
}

function doLinkSelected(eng, link) {
    console.log("proto is ", eng.prototype)
    eng.linkSelected(link);
}
