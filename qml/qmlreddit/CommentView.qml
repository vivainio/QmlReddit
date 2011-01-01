import Qt 4.7

import "redditengine.js" as RE



Rectangle {
    x: width + 200

    id: root

    signal commentSelected
    signal reqPreview(string url)
    signal reqLinks

    QtObject {
        id: priv
        property int lastVote: 1000
        property variant linkData
        property int colorspeed : 400
    }

    ListModel {        
        id: mdlComments

    }


    function setLink(lnk) {
        RE.priv(root).linkData = lnk
        progressInd.show()
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
                score: d.ups - d.downs
        }


        result.push(co)

        if (d.replies) {
            var chi = d.replies.data.children
            for (var i in chi) {
                //console.log('recursing at ', depth)
                emitComments(chi[i], depth + 1, result)

            }
        }
        progressInd.hide()

        //console.log('replies ', chi)

    }

    function clear() {
        mdlComments.clear()
    }

    function populate(json) {
        //console.log("comment_json ", json)
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
        mdlComments.clear()
        for (var i in aggr) {
            var val = aggr[i]
            mdlComments.append(val)
            //console.log("body ", unescape(val.body))

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
            width: ListView.view.width
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
                color: score > 0 ? "black" : "gray"
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
                color: score > 20 ? "red" : "black"
                font.bold: score > 50 ? true : false
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
                height: 80
                Row {
                    spacing: 30
                    anchors.fill: parent
                    RButton {
                        buttonLabel: "+"
                        color: priv.lastVote != 1 ? "blue" : "yellow"
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
        Item {
            width: 1
            height: 1
        }
    }

    ListView {
        anchors.fill: parent
        model: mdlComments
        delegate: dlgComments
        spacing: 5


        header: appState.loggedIn ? voteRow : nullVoteRow

        footer: Rectangle {
            height: imgNext.height
        }
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


}
