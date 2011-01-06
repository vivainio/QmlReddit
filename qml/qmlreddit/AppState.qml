import Qt 4.7

QtObject {
    property bool loggedIn : false

    property string linkSelection: "Hot"
    function checkLogin() {
        var cook = mdlRedditSession.cookies()
        if (cook.reddit_session) {
            loggedIn = true
        } else {
            loggedIn = false
        }

    }

}

