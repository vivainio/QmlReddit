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

    property string homeUrl: ""
    //property int navbtnsize: 80

    property int navbtnsize: 60


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
        homeUrl = url
        wv.scale = 1.0
        wv.contentScale = 1.0

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
    /*
    RButton {
        opacity: 0.5
        id: navforward
        width: navbtnsize * 0.8
        buttonLabel: ">"
        anchors.right: zout.left
        anchors.rightMargin: 20
        anchors.bottom: parent.bottom
        onClicked: {
            wv.forward.trigger()
        }


    }
    */
    RButton {
        opacity: 0.5
        id: navback
        width: navbtnsize * 0.8

        buttonLabel: "<"
        anchors.right: zout.left
        anchors.rightMargin: 40
        anchors.bottom: parent.bottom
        visible: homeUrl != url //wv.back.enabled
        onClicked: {
            setUrl(homeUrl)
            //wv.back.trigger()
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
