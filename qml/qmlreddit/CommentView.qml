import Qt 4.7

import "redditengine.js" as RE
import "Scrollable"



Rectangle {
    //x: width + 200

    id: root

    signal commentSelected
    signal reqPreview(string url)
    signal reqLinks
    color: mainview.theme.bg
    QtObject {
        id: priv
        property int lastVote: 1000
        property variant linkData
        property int colorspeed : 400
    }

    Connections {
        target: appState
        onLightModeChanged: {
            lstComments.delegate = appState.lightMode ? dlgCommentsLight : dlgComments
        }


    }


    function pruneComments() {
        var aggr = RE.priv(root).commentList
        if (!aggr) return
        aggr.sort(function (l,r) {
                      return r.score - l.score
                  }

        )

        for (var i in aggr) {
            aggr[i].depth = 0
        }
        aggr.splice(100, aggr.length - 100)


        RE.priv(root).commentList = aggr

        publishCommentList()

    }

    Keys.onPressed: {
        console.log(event.key)

        /*
        if (event.key == Qt.Key_Down) {
            lstComments.incrementCurrentIndex()
        }

        if (event.key == Qt.Key_Up) {
            lstComments.decrementCurrentIndex()

        }
        */

        if (event.key == Qt.Key_T) {

            webpreview.setUrl("about:blank")
            pruneComments()
            infoBanner.show("Top comments")

        }

        if (event.key == Qt.Key_L) {
            lstComments.delegate = dlgCommentsLight

            appState.lightMode = !appState.lightMode
            if (appState.lightMode)
                infoBanner.show("Light mode")


        }

        if (event.key == Qt.Key_I) {
            appState.incognitoMode = !appState.incognitoMode
            if (appState.incognitoMode) {
                infoBanner.show("Incognito mode")
            }
            else {
                infoBanner.show("Leaving incognito")

            }

        }

    }


    ListModel {        
        id: mdlComments

    }


    function setLink(lnk) {
        RE.priv(root).linkData = lnk
        if (lnk.comments > 0) {
            progressInd.show()
        } else {
            clear()
        }

        priv.lastVote = lnk.vote

        appState.checkLogin()

    }

    function emitComments(jsobj, depth, result) {
        var co = {}
        //RE.dump(jsobj)
        var d = jsobj['data']

        if (!d || !d.body)
            return

        //RE.dump(d)
        co = {
                body : d.body_html,
                author: d.author,
                depth: depth,
                score: d.ups - d.downs,
                name: d.name,
                vote: d.likes === null ? 0 : d.likes ? 1 : -1
        }


        result.push(co)

        if (d.replies) {
            var chi = d.replies.data.children
            for (var i in chi) {
                //console.log('recursing at ', depth)
                emitComments(chi[i], depth + 1, result)

            }
        }
        //progressInd.hide()

        //console.log('replies ', chi)

    }

    function clear() {
        mdlComments.clear()
    }

    function publishCommentList() {
        clear()

        var aggr = RE.priv(root).commentList

        for (var i in aggr) {
            var val = aggr[i]
            mdlComments.append(val)
        }
    }

    function populate(json) {
        //console.log("comment_json ", json)
        progressInd.hide()
        var obj = eval(json)
        //console.log("obj ",obj)
        var uh = obj[0]['data']['modhash']
        if (uh && uh.length > 0) {
            mdlRedditSession.setModhash(uh)

        }

        //console.log('user modhash ', uh)
        var items = obj[1]['data']['children']
        var aggr = []
        for (var it in items) {
            emitComments(items[it], 0, aggr)

        }

        //var comments = obj[1]['data']['']

        RE.priv(root).commentList = aggr

        if (appState.topCommentsMode) {
                pruneComments()
        } else {

            publishCommentList()
        }

    }

    Component {
        id : dlgCommentsLight

        Rectangle {
            color: mainview.theme.bg
            height: txtComL.height + 5
            width: mainview.width
            Text {
                width: parent.width
                id: txtComL
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                textFormat: Text.RichText
                text: body
                color: mainview.theme.fg
            }
        }
    }

    Component {

        id: dlgComments


        BorderImage {
            //width: parent.width
            height: txtCom.height + 30

            id: backgroundImage
            source: "pics/listitem.png"
            //width: ListView.view.width
            width: mainview.width
            border.bottom: 5
            border.top: 5
            border.left: 5
            border.right: 30

            Text {
                x: depth * 5
                y: 10
                id: txtCom
                text: body
                textFormat: Text.RichText
                wrapMode: "WrapAtWordBoundaryOrAnywhere"
                width: parent.width - x
                color: score > 0 ? mainview.theme.fg : mainview.theme.fg2
                onLinkActivated: {
                    console.log("Activate")
                    Qt.openUrlExternally(link)
                }
            }


            Text {
                id: tScore
                anchors {
                    bottom: parent.bottom
                    bottomMargin: 1
                    right: parent.right
                    rightMargin: 5

                }

                text: score
                color: score > 20 ? "red" : mainview.theme.fg
                font.bold: score > 50 ? true : false
            }
            MouseArea {

                anchors {
                    bottom: parent.bottom
                    right: parent.right
                    top: parent.top
                }
                width: 40

                onClicked: {
                    commentVote.visible = true
                    commentVote.setComment(mdlComments.get(index))
                }
            }


            Text {
                anchors {
                    right: tScore.left
                    top: tScore.top
                    rightMargin: 30
                }

                text: author
                color: "gray"

            }


        }

    }

    Component {
        id: voteRow
        Rectangle {
                height: 160
                width: parent.width
                color: mainview.theme.bg

                Row {
                    spacing: 20
                    anchors {
                        right: parent.right
                        top: parent.top
                        topMargin: 80
                        bottom: parent.bottom
                    }

                    RButton {
                        buttonLabel: "+"
                        color: priv.lastVote != 1 ? "blue" : "yellow"
                        border.color: mainview.theme.bg
                        onClicked: {
                            mdlRedditSession.vote(RE.priv(root).linkData.name, 1)
                            //infoBanner.show("Upvote!")
                            RE.priv(root).linkData.vote = 1
                            priv.lastVote = 1
                        }
                        Behavior on color {
                            ColorAnimation { duration: priv.colorspeed }
                        }
                    }
                    RButton {
                        buttonLabel: "0"
                        color: priv.lastVote != 0 ? "white" : "yellow"
                        border.color: mainview.theme.bg
                        onClicked: {
                            mdlRedditSession.vote(RE.priv(root).linkData.name, 0)
                            //infoBanner.show("Neutral!")
                            RE.priv(root).linkData.vote = 0
                            priv.lastVote = 0
                        }
                        Behavior on color {
                            ColorAnimation { duration: priv.colorspeed }
                        }

                    }

                    RButton {
                        buttonLabel: "-"
                        color: priv.lastVote != -1 ? "red" : "yellow"
                        border.color: mainview.theme.bg
                        onClicked: {
                            mdlRedditSession.vote(RE.priv(root).linkData.name, -1)
                            //infoBanner.show("Downvote!")
                            RE.priv(root).linkData.vote = -1
                            priv.lastVote = -1
                        }
                        Behavior on color {
                            ColorAnimation { duration: priv.colorspeed }
                        }

                    }
                }

        }

    }

    Component {
        id: nullVoteRow
        Rectangle {
            color: mainview.theme.bg
            height: 80
            width: root.width
            Text {
                color: mainview.theme.fg2
                anchors.centerIn: parent
                text: appState.incognitoMode ? "Incognito" : (!appState.loggedIn ? "Login to vote" : "")

            }

        }
    }

    ListView {
        id: lstComments
        anchors.fill: parent
        model: mdlComments
        delegate: appState.lightMode ? dlgCommentsLight : dlgComments
        spacing: 5


        header: appState.loggedIn && !appState.incognitoMode ? voteRow : nullVoteRow

        footer: Rectangle {
            height: imgNext.height
        }
    }

    ScrollBar {
        flickable: lstComments
        vertical: true
    }

    ImgButton {
        id: imgNext
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        buttonImage: "pics/go-next.svg"
        //buttonLabel: "Preview"
        onClicked: reqPreview("url")

    }

    ImgButton {
        id: imgPrev
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        buttonImage: "pics/go-previous.svg"
        //buttonLabel: "Links"
        onClicked: reqLinks()        
    }
    ProgressInd {
        id: progressInd

    }

    CommentVote {
        id: commentVote
        anchors.fill: parent


    }

}
