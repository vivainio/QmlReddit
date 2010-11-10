import Qt 4.7
import QtWebKit 1.0


Rectangle {
    width: parent.width
    height: parent.height

    x: 1000
    property alias url: wv.url
    signal reqBack

    WebView {
        id: wv
        anchors.fill: parent
    }

    RButton {
        buttonLabel: "Back"
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        onClicked: {
            reqBack()
        }
    }


}
