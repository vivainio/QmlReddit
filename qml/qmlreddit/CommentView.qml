import Qt 4.7

import "redditengine.js" as RE

Rectangle {
    x: width + 200

    signal commentSelected
    signal reqPreview(string url)
    signal reqLinks

    ListModel {
        id: mdlComments

    }

    function emitComments(jsobj, depth, result) {
        var co = {}
        RE.dump(jsobj)
        var d = jsobj['data']

        co = {
                body : d.body_html,
                author: d.author,
                depth: depth
        }



        if (d.replies) {
            var chi = d.replies.data.children
            for (var i in chi) {
                console.log('recursing at ', depth)
                emitComments(chi[i], depth + 1, result)

            }
        }

        console.log('replies ', chi)
        result.push(co)

    }

    function populate(json) {
        var obj = eval(json)
        console.log("obj ",obj)
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
            height: txtCom.height + 20

            id: backgroundImage
            source: "pics/listitem.png"
            //width: ListView.view.width
            width: ListView.view.width
            border.bottom: 5
            border.top: 5
            border.left: 5
            border.right: 30

            Text {
                x: depth * 20
                y: 10
                id: txtCom
                text: body + " " + depth
                textFormat: Text.RichText
                wrapMode: "WrapAtWordBoundaryOrAnywhere"
                width: parent.width - 5
            }

        }

    }

    ListView {
        anchors.fill: parent
        model: mdlComments
        delegate: dlgComments
        spacing: 5
        footer: Rectangle {
            height: imgNext.height
        }
    }

    RButton {
        id: imgNext
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        buttonLabel: "Preview"
        onClicked: reqPreview("url")
        opacity: 0.8

    }

    RButton {
        id: imgPrev
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        buttonLabel: "Links"
        onClicked: reqLinks()
        opacity: 0.8
    }

    // we overlay back / preview button over listview...



    /*
    Text {
        anchors.fill: parent
        text: "hello comments"

        MouseArea {
            anchors.fill: parent
            onClicked: {
                commentSelected()
                console.log("doeoehdhd")
                //commentSelected()
            }
        }

    }
    */
}
