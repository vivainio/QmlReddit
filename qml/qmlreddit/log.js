// NOTE: must be always wrapped with namespace
/*
 * for console logging and asserting - dumps entire element tree - returns the message string
 */

var dumpLevels = 5; // Max recursion depth on unraveling objects
var enabled = true; // logging enabled
var dump = function (msg, ob) {
    var crlf = "\n";

    var buildMessage = function(msgR, obR, recursionLimit) {    // create the message (without trailing crlf)
        var prop;
        var s;
        var deli;
        var i;
        var isArray = function(o) {
            return (o && typeof o === 'object' && o.constructor === Array)
        }

        s = msgR;
        if (obR !== undefined) {
            if (typeof obR === 'object') {
                if (recursionLimit <= 0) {
                    s = buildMessage(msgR, "<object> (too deep)", 1);
                } else {
                    if (isArray(obR)) {
                        for (i = 0; i < obR.length; i++) {
                            s += crlf + buildMessage(msgR+"["+i+"]", obR[i], recursionLimit-1);
                        }
                    } else {
                        s = buildMessage(msgR + "{", undefined, 1);
                        for (prop in obR) {
                            deli = ".";
                            if (obR.hasOwnProperty && !obR.hasOwnProperty(prop)) {   // QML Bug 4.7.1 - Not all Qt fake Js objects have hasOwnProperty() - at least the Ns in "import "x.js" as Ns"
                                deli = ".prototype.";
                            }
                            s += crlf + buildMessage(msgR + deli + prop, obR[prop], recursionLimit-1);
                        }
                        s += crlf + buildMessage(msgR + "}", undefined, 1);
                    }
                }
            } else if (typeof obR === 'function') {
                s += ":function()";
            } else if (typeof obR == 'number' || typeof obR == 'boolean') { // primitive type obR
                s += ":" + obR;
            } else if (typeof obR == 'string') {
                s += ':"'+obR+'"';
            } else {
                s += ": ["+typeof obR+"]"
            }
        }
        return s;   // without the trailing crlf
    }
    if (enabled) console.log(buildMessage(msg, ob, dumpLevels))
}

var assert = function (expr, err, obj) {  // expr must be true or else error
    if (!expr) dump("Assertion failed: "+err, obj);
}
