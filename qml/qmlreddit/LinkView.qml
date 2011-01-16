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

    function activationComplete() {
        commentview.item.clear()

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

            ImgButton {
                anchors.horizontalCenter: parent.horizontalCenter
                //buttonLabel: "More"
                buttonImage: "pics/list-add.svg"
                color: "blue"
                onClicked: {
                    progressInd.show()
                    RE.eng().fetchMore()
                }
            }

        }

    }

    ProgressInd {
        id: progressInd
    }

}
