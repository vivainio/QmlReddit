import Qt 4.7
import QtWebKit 1.0


Rectangle {
    width: 800
    height: 450
    x: 1000
    property alias url: wv.url

    WebView {
        id: wv
        anchors.fill: parent
    }

    RButton {
        label: "Back"
        anchors.right: parent.right
        anchors.bottom: parent.bottom
    }


}
