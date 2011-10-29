import Qt 4.7

import "redditengine.js" as RE


Rectangle {
    id: root
    property Item previousView

    property alias text: inpAnswer.text
    property alias prompt: tPrompt.text

    color: mainview.theme.bg
    signal accepted(string text)

    function launch(promptText, previous, callback) {
        var p = RE.priv(root)
        prompt = promptText
        previousView = previous
        p.callback = callback
        inpAnswer.focus = true
        //viewSwitcher.switchView(root, true)

    }

    function _accept() {
        var p = RE.priv(root)
        var cb = p.callback
        cb(text)
        //inpAnswer.closeSoftwareInputPanel()
    }

    Column {
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            topMargin: 100
        }


        TText {
            id: tPrompt
            text: "Prompt text"
            color: mainview.theme.fg
        }

        TextInput {

            //focus: true
            id: inpAnswer
            text: ""
            anchors.left: parent.left
            anchors.right: parent.right
            height: 50
            Keys.onReturnPressed: _accept()

            Keys.onEnterPressed: _accept()

            font.pixelSize: mainview.theme.defaultTextSize
            //color: focus ? "blue" : "white"
            inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText
            Rectangle {
                border.width: 1
                z: parent.z - 1
                color: inpAnswer.activeFocus ? "lightblue" : "white"
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
            _accept()
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
        onClicked: {
            //parent.forceActiveFocus()
            //parent.focus = true
            viewSwitcher.switchView(previousView, true, "instant")
            inpAnswer.closeSoftwareInputPanel()
        }
    }

}
