import Qt 4.7
import QtWebKit 1.0
import "Scrollable"

Rectangle {
    //width: parent.width
    //height: parent.height

    //x: width + 200
    property alias url: wv.url
    signal reqBack

    property real zoomfact: 0

    FlickableWebView {
        id: wv
        //pressGrabTime:
        anchors.fill: parent
    }


    ScrollBar {
        flickable: wv
        color: "red"
    }

    function setUrl(newurl) {
        if (url != newurl) {
            url = newurl
        }
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

    RButton {
        opacity: 0.5
        width: 50
        id: zin
        buttonLabel: "Z+"
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        onClicked: {
            wv.contentScale += 0.1
        }
        onRepeated: {
            wv.contentScale += 0.1
        }

    }
    RButton {
        opacity: 0.5
        id: zout
        width: 50
        buttonLabel: "Z-"
        anchors.right: zin.left
        anchors.rightMargin: 20
        anchors.bottom: parent.bottom
        onClicked: {
            wv.contentScale -= 0.1
        }
        onRepeated: {
            wv.contentScale -= 0.1
        }

    }
    RButton {
        opacity: 0.5
        id: navforward
        width: 50
        buttonLabel: ">"
        anchors.right: zout.left
        anchors.rightMargin: 20
        anchors.bottom: parent.bottom
        onClicked: {
            wv.forward.trigger()
        }


    }
    RButton {
        opacity: 0.5
        id: navback
        width: 50
        buttonLabel: "<"
        anchors.right: navforward.left
        anchors.rightMargin: 20
        anchors.bottom: parent.bottom
        onClicked: {
            wv.back.trigger()
        }


    }



    TText {
        anchors.right: parent.right
        anchors.bottom:  parent.bottom
        anchors.rightMargin: 5

        color: "green"
        text: wv.progress < 1 ? Math.floor(wv.progress * 100) + "%" : ""
    }


    /*
    RButton {
        id: back
        buttonLabel: "Back"
        anchors.right: zout.left
        anchors.rightMargin: 5
        anchors.bottom: parent.bottom
        onClicked: {
            if (wv.back.enabled)
                wv.back.trigger()
        }

    }
    */


}
