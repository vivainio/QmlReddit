import Qt 4.7
import ".."

Rectangle {
    property int margin: 20
    property int contentWidth: toolbarItemText.width + margin

    height: parent.minimumItemHeight
    color: "black"

    // Toolbar item background
    BorderImage {
        id: toolbarItemImage
        source: "pics/toolbaritem.png"
        width: parent.width
        height: parent.height
        border.left: 10; border.top: 10
        border.right: 10; border.bottom: 10
    }

    // Selection highlight
    BorderImage {
        id: toolbarItemPressedImage
        source: "pics/toolbaritem_p.png"
        width: parent.width
        height: parent.height
        border.left: 10; border.top: 10
        border.right: 10; border.bottom: 10

        opacity: toolbar.current == index ? 1 : 0
    }

    // Icon and title
    Column {
        anchors.centerIn: parent

        Image {
            id: toolbarItemIcon

            property string iconSource: toolbar.views[index].toolbarItemIcon

            source: iconSource
            anchors.horizontalCenter: parent.horizontalCenter
        }

        TText {
            id: toolbarItemText

            anchors.horizontalCenter: parent.horizontalCenter
            text: toolbar.views[index].toolbarItemTitle
            color: "lightgray"
            style: "Raised"
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: toolbarItemImage
        // Switch the selected toolbar item
        onClicked: toolbar.current = index
    }
}
