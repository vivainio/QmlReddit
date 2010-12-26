import Qt 4.7
import "redditengine.js" as RE

Rectangle {
    id: container
    //anchors.fill: parent
    width: parent.width
    height: parent.height
    x: width + 200

    signal linkSelected(int selIndex);

    // hidden by default

    function start() {
        progressInd.show()

    }

    Connections {
        target: mdlRedditSession
        onLinksAvailable: {
            progressInd.hide()
        }

    }


    ListView {

        id: lvLinks
        anchors.fill: parent

        model: mdlLinks
        //delegate: deLinks
        delegate: LinkViewDelegate {}
        footer: Item {
            height: 60
            width: container.width

            RButton {
                anchors.horizontalCenter: parent.horizontalCenter
                buttonLabel: "More"
                onClicked: {
                    RE.eng().fetchMore()
                }
            }


        }

    }

    Component {
        id: deLinks
        Rectangle {
            id: rrect
            height: childrenRect.height  + 10
            width: lvLinks.width
            Rectangle {
                x:0
                y:0
                id: thumbarea
                width: thumbnail.length > 0 ? 60 : 0
                height: 60                
                border.width: 1
                Image {
                    anchors.fill: parent
                    id: tnail
                    height: 60
                    width: 60
                    source: thumbnail
                }


            }

            Text {
                wrapMode: "WrapAtWordBoundaryOrAnywhere"
                id: dscIt
                text: desc
                //width: lvLinks.width - thumbarea.width - 100

                anchors.right: rrect.right
                anchors.rightMargin: 50
                anchors.left: thumbarea.right
                anchors.leftMargin: 4
            }

            Text {
                id: txtIt
                text: score
                //scale: 0.7
                y: 0
                color: score > 100 ? "red" : "black"

                anchors.right: rrect.right
                anchors.rightMargin: 10

            }

            Text {
                id: tCommentCount
                //scale: 0.7
                anchors.left: thumbarea.right
                anchors.leftMargin: 10
                y: dscIt.height + 2
                text: comments
                color: "blue"

            }


            /*r
            Rectangle {
                border.width: 3
                anchors.fill: tnail
            }
            */


            MouseArea {
                id: ma
                width: rrect.width
                height: dscIt.height + txtIt.height + 10

                //anchors.fill: parent
                onClicked: {
                    //console.log("index ", index)
                    linkSelected(index)
                }

            }

        }


    }
    ProgressInd {
        id: progressInd
    }

}
