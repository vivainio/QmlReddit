import Qt 4.7

import "redditengine.js" as RE


Rectangle {
    id: root
    property Item previousView

    property alias text: inpAnswer.text
    property alias prompt: tPrompt.text

    signal accepted(string text)

    function launch(promptText, previous, callback) {
        var p = RE.priv(root)
        prompt = promptText
        previousView = previous
        p.callback = callback
        //viewSwitcher.switchView(root, true)

    }

    Column {
        anchors {
            left: parent.left
            right: parent.right
        }


        Text {
            id: tPrompt
            text: "Prompt text"
        }

        TextInput {

            focus: true
            id: inpAnswer
            text: ""
            anchors.left: parent.left
            anchors.right: parent.right
            height: 50
            //color: focus ? "blue" : "white"
            inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText
            Rectangle {
                border.width: 1
                z: parent.z - 1
                color: inpAnswer.focus ? "lightblue" : "white"
                anchors {
                    fill: parent
                    topMargin: -1
                    bottomMargin: -1
                    leftMargin: -1
                    rightMargin: -1
                }

            }
        }
    }

    ImgButton {
        id: imgNext
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        buttonImage: "pics/go-next.svg"
        onClicked: {
            var p = RE.priv(root)
            var cb = p.callback
            cb(text)
        }

    }

    ImgButton {
        id: imgCancel
        anchors {
            left: parent.left
            bottom: parent.bottom
        }
        buttonImage: "pics/process-stop.svg"
        //buttonLabel: "Preview"
        onClicked: viewSwitcher.switchView(previousView, true)
    }

}
