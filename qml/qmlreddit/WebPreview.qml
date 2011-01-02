import Qt 4.7
import QtWebKit 1.0


Rectangle {
    width: parent.width
    height: parent.height

    x: width + 200
    property alias url: wv.url
    signal reqBack


    FlickableWebView {
        id: wv
        //pressGrabTime:
        anchors.fill: parent
    }

    Text {
        anchors.right: parent.right
        anchors.bottom:  parent.bottom
        anchors.rightMargin: 50

        color: "yellow"
        text: wv.progress < 1 ? Math.floor(wv.progress * 100) + "%" : ""
    }

    ImgButton {
        buttonImage: "pics/go-previous.svg"
        //buttonLabel: "Back"
        anchors.left: parent.left
        anchors.bottom: parent.bottom        
        anchors.bottomMargin: 0    
        onClicked: {
            reqBack()
        }
    }


}
