import Qt 4.7

Storage {
    property bool loggedIn : false

    property bool lightMode : false

    property bool topCommentsMode: false

    property bool incognitoMode: false

    property string linkSelection: "Hot"

    name: "qmreddit"
    function checkLogin() {
        var cook = mdlRedditSession.cookies()
        if (cook.reddit_session) {
            loggedIn = true
        } else {
            loggedIn = false
        }

    }

}

