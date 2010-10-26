function init() {
    console.log("hello")

}


function RedditEngine() {
    this._init();
}

RedditEngine.prototype = {
    _init : function() {
        this.currentlink = {};
    },

    setCurrent : function(link) {
        this.currentlink = link;
    }
}

function create() {
    console.log("creating")
    return new RedditEngine();
}
