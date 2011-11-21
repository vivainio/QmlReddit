import Qt 4.7
import "redditengine.js" as RE

Rectangle {
    id: container
    //anchors.fill: parent

    property string currentCategory : ""
    color: mainview.theme.bg
    signal linkSelected(int selIndex);

    // hidden by default

    function start() {
        progressInd.show()
        currentCategory = RE.eng().currentCategory()

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
        delegate: LinkViewDelegate2 {}


        header: Item {
            id: lvheader
            height: 80
            //width: parent.width

            Row {
                height: 80
                spacing: 30
                id: lsrow
                Repeater {
                   model: ["Hot", "New", "Top", "Saved", "Controversial"]
                   Item {
                       width: telem.width
                       height: 40

                       TText {
                           id: telem
                           height: 40
                           //width: 50
                           text: modelData
                           color: modelData == appState.linkSelection ? "White" : "gray"
                       }
                       MouseArea {
                           anchors.fill: parent
                           onClicked: {
                               appState.linkSelection = modelData

                           }
                       }
                   }
                }
            }

            TText {
                id: tsubreddit
                y: 30
                height: 40
                x: 0
                width: 100

                color: "blue"
                text: currentCategory + "/"
            }

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
