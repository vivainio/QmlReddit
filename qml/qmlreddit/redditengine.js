function init() {
    console.log("hello")

}


function RedditEngine() {
    this._init();
    // this works, but calling from qml doesn't
    this.linkSelected('blah')
}

RedditEngine.prototype = {
    linkSelected : function(link) {
        this.currentlink = link;
    },

    _init : function() {
        this.currentlink = {};
    }


};

function create() {
    console.log("creating")
    return new RedditEngine();
}

function dump(obj) {
    for (var i in obj ) {
        console.log(i)
    }
}
