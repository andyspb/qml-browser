import QtQuick 2.0
import QtQuick.Layouts 1.0

Item {
    id: exitFullScreenComponent
    anchors.fill: parent
    property Item parentItem: parent

    function onClicked() {
        // destroy object is needed when you dynamically create it
        console.log('>>> [Exit full screen] onClicked()')
        console.log('parentItem:' + parentItem)
        parentItem.onExitFullScreenClick()
        destroy()
    }

    PropertyAnimation {
        target: exitFullScreenComponent
        property: "opacity"
        duration: 400
        from: 0
        to: 1
        easing.type: Easing.InOutQuad
        running: true
    }

    Rectangle {
        id: dialogWindow
        width: 120
        height: 40
        radius: 10
        color: "gray"
        anchors {
            top: parent.top
            topMargin: 10
            horizontalCenter: parent.horizontalCenter
        }
        Text {
            anchors.top: parent.top
            anchors.topMargin: 5
            text: "Exit full screen"
            color: "white"
            anchors {
                left: parent.left
                leftMargin: 5
            }
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                exitFullScreenComponent.onClicked()
            }
        }
    }
}
