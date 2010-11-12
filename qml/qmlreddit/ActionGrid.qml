import Qt 4.7

Rectangle {
    width: 640
    height: 480

    property alias model : gv.model

    ListModel {
        id: _testmodel
        ListElement { catName : 'cat1'  }
        ListElement { catName : 'cat2' }
    }

    signal itemSelected(string itemName)

    GridView {
        id : gv
        model:  _testmodel
        cellWidth: 200
        anchors.fill: parent
        delegate: Component {
            RButton {
                buttonLabel: catName
                width: 150
                height: 80
                onClicked: {
                    itemSelected(catName)
                }
            }
        }
    }
}
