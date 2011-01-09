import Qt 4.7

QtObject {
    property bool loggedIn : false

    property bool lightMode : false

    property bool topCommentsMode: false

    property bool incognitoMode: false

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

