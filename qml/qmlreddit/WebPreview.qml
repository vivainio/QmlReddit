import Qt 4.7
import QtWebKit 1.0
import "Scrollable"
import QtQuick 1.1

Rectangle {
    //width: parent.width
    //height: parent.height

    //x: width + 200
    property alias url: wv.url
    signal reqBack

    property real zoomfact: 0

    property int navbtnsize: 80


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
        width: navbtnsize
        height: navbtnsize
        id: zin
        buttonLabel: "Z+"
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.rightMargin: 5

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
        width: navbtnsize
        height: navbtnsize
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
        width: navbtnsize
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
        width: navbtnsize

        buttonLabel: "<"
        anchors.right: navforward.left
        anchors.rightMargin: 30
        anchors.bottom: parent.bottom
        onClicked: {
            wv.back.trigger()
        }

    }

    Rectangle {
        visible: wv.progress < 1
        color: "blue"
        anchors.right: parent.right
        anchors.bottom:  zin.top
        anchors.bottomMargin: 5
        anchors.left: zout.left
        height: 40


        TText {            
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 5

            color: "yellow"
            text: wv.progress < 1 ? "Loading " + Math.floor(wv.progress * 100) + "%" : ""
        }
    }


    /*r
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
