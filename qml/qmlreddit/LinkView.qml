import Qt 4.7
import "redditengine.js" as RE

Rectangle {
    id: container
    //anchors.fill: parent

    color: mainview.theme.bg
    signal linkSelected(int selIndex);

    // hidden by default

    function start() {
        progressInd.show()

    }

    function activationComplete() {
        if (commentview.item) {
            commentview.item.clear()
        }

    }



    ListView {

        id: lvLinks
        anchors.fill: parent

        model: mdlLinks
        //delegate: deLinks
        delegate: LinkViewDelegate {}
        header: Item {
            height: 80
            width: 1
        }

        footer: Item {
            height: 100
            width: container.width

            ImgButton {
                id: b
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.horizontalCenterOffset: -50
                //buttonLabel: "More"
                buttonImage: "pics/list-add.svg"
                color: "blue"
                onClicked: {
                    progressInd.show()
                    RE.eng().fetchMore()
                }
            }
            TText {
                anchors {
                    left: b.right
                    leftMargin: 12
                    verticalCenter: b.verticalCenter

                }
                color: mainview.theme.fg2
                text: "Show more..."
            }

        }

    }


}
