import QtQuick 2.0
import QtQuick.Layouts 1.0

Item {
id: dialogComponent
anchors.fill: parent

    // Add a simple animation to fade in the popup
    // let the opacity go from 0 to 1 in 400ms
    PropertyAnimation {
        target: dialogComponent;
        property: "opacity";
        duration: 400; from: 0; to: 1;
        easing.type: Easing.InOutQuad ;
        running: true
    }

    // This rectangle is the actual popup
    Rectangle {
        id: dialogWindow
        width: 85
        height: 100
        radius: 10
        color: "gray"
        anchors {
            top: parent.bottom
            topMargin: 10
            right: parent.right
            rightMargin: -30
        }
        ColumnLayout {
            Text {
                anchors.top: parent.top
                anchors.topMargin: 5
                text: "History"
                color: "white"
                anchors {
                    left: parent.left
                    leftMargin: 5
                }
                // For demo I do not put any buttons, or other fancy stuff on the popup
                // clicking the whole dialogWindow will dismiss it
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        // destroy object is needed when you dynamically create it
                        console.log('>>>[History] dialogWindow.MouseArea.onClicked()')
                        dialogComponent.destroy()
                    }
                }
            }
            Text {
                anchors.top: parent.top
                anchors.topMargin: 25
                text: "Bookmarks"
                color: "white"
                anchors {
                    left: parent.left
                    leftMargin: 5
                }
                // For demo I do not put any buttons, or other fancy stuff on the popup
                // clicking the whole dialogWindow will dismiss it
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        // destroy object is needed when you dynamically create it
                        console.log('>>>[Bookmarks] dialogWindow.MouseArea.onClicked()')
                        dialogComponent.destroy()
                    }
                }
            }
            Text {
                anchors.top: parent.top
                anchors.topMargin: 50
                text: "Settings"
                color: "white"
                anchors {
                    left: parent.left
                    leftMargin: 5
                }
                // For demo I do not put any buttons, or other fancy stuff on the popup
                // clicking the whole dialogWindow will dismiss it
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        // destroy object is needed when you dynamically create it
                        console.log('>>>[Settings] dialogWindow.MouseArea.onClicked()')
                        dialogComponent.destroy()
                    }
                }
            }
            Text {
                anchors.top: parent.top
                anchors.topMargin: 75
                text: "Encoding"
                color: "white"
                anchors {
                    left: parent.left
                    leftMargin: 5
                }
                // For demo I do not put any buttons, or other fancy stuff on the popup
                // clicking the whole dialogWindow will dismiss it
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        // destroy object is needed when you dynamically create it
                        console.log('>>>[Encoding] dialogWindow.MouseArea.onClicked()')
                        dialogComponent.destroy()
                    }
                }
            }
        }
    }
}
