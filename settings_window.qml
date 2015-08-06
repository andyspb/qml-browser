import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Window 2.0
import QtQuick.Dialogs 1.2

//Rectangle {
//        id: settingWindow
//        width: 200;
//        height: 200

//    //    flags: {Qt.Dialog, Qt.WindowStaysOnTopHint}
//    //    modality: Qt.WindowModal

//        border.width: 1
//        border.color: "red"
//        Button {
//            anchors.centerIn: parent
//            text: "Click me"
//            onClicked: {
//                console.log('>>> settingWindow.onClicked parent:'+parent)
//            }
//        }
//}

Dialog {
    visible: true
    title: "Blue sky dialog"

    contentItem: Rectangle {
        color: "lightskyblue"
        implicitWidth: 300
        implicitHeight: 300
        Text {
            text: "Hello blue sky!"
            color: "navy"
            anchors.centerIn: parent
        }
    }
}
