/****************************************************************************
**
** Copyright (C) 2013 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the QtWebEngine module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of Digia Plc and its Subsidiary(-ies) nor the names
**     of its contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.1
import QtWebEngine 1.0
import QtQuick.Controls 1.0
import QtQuick.Controls.Styles 1.0
import QtQuick.Layouts 1.0
import QtQuick.Window 2.1
import QtQuick.Controls.Private 1.0

ApplicationWindow {
    id: browserWindow
    function load(url) { currentWebView.url = url }
    property Item currentWebView: tabs.currentIndex < tabs.count ? tabs.getTab(tabs.currentIndex).item : null

    width: 1300
    height: 900
    visible: true
    title: currentWebView && currentWebView.title
    // Create a styleItem to determine the platform.
    // When using style "mac", ToolButtons are not supposed to accept focus.
    StyleItem { id: styleItem }
    property bool platformIsMac: styleItem.style == "mac"

    Action {
        id: focus
        shortcut: "Ctrl+L"
        onTriggered: {
            addressBar.forceActiveFocus();
            addressBar.selectAll();
        }
    }
    Action {
        shortcut: "Ctrl+R"
        onTriggered: {
            if (currentWebView)
                currentWebView.reload()
        }
    }
    Action {
        shortcut: "Ctrl+T"
        onTriggered: {
            tabs.createEmptyTab()
            addressBar.forceActiveFocus();
            addressBar.selectAll();
        }
    }
    Action {
        shortcut: "Ctrl+W"
        onTriggered: {
            if (tabs.count == 1)
                browserWindow.close()
            else
                tabs.removeTab(tabs.currentIndex)
        }
    }

    Action {
        shortcut: "Esc"
        onTriggered: {
            console.log('>>> Escape actipon')
            tabs.visible = true
            navigationBar.visible = true
        }
    }

    toolBar: ToolBar {
        id: navigationBar
        style: ToolBarStyle {
            background: Rectangle {
                color: "black"
            }
        }
             RowLayout {
                anchors.fill: parent;
                ToolButton {
                    id: backButton
                    iconSource: "icons/go-previous.png"
                    onClicked: currentWebView.goBack()
                    enabled: currentWebView && currentWebView.canGoBack
                    activeFocusOnTab: !browserWindow.platformIsMac
                }
                ToolButton {
                    id: forwardButton
                    iconSource: "icons/go-next.png"
                    onClicked: currentWebView.goForward()
                    enabled: currentWebView && currentWebView.canGoForward
                    activeFocusOnTab: !browserWindow.platformIsMac
                }
                TextField {
                    id: addressBar
                    anchors.leftMargin: 5
                    anchors.rightMargin: 5
                    Image {
                        anchors.leftMargin: 2
                        anchors.verticalCenter: addressBar.verticalCenter;
                        x: 5
                        z: 2
                        id: faviconImage
                        width: 16; height: 16
                        source: currentWebView && currentWebView.icon
                    }
                    style: TextFieldStyle {
                        background: Rectangle {
                            color: "gray"
                            implicitHeight: 26
                            radius: 13
                        }
                        padding {
                            left: 26;
                            right: 26;
                        }
                    }
                    focus: true
                    Layout.fillWidth: true
                    text: currentWebView && currentWebView.url
                    onAccepted: currentWebView.url = utils.fromUserInput(text)

                    ToolButton {
                        id: reloadButton
                        iconSource: "icons/view-refresh.png"
                        onClicked: currentWebView.reload()
                        activeFocusOnTab: !browserWindow.platformIsMac
                        anchors.right: addressBar.right
                        anchors.rightMargin: 2
                        anchors.verticalCenter: addressBar.verticalCenter;
                    }

                }
                ToolButton {
                    id: zoomButton
                    iconSource: "icons/zoom_in_16.png"
//                    onClicked: onClickZoomButton()navigationBar
                    activeFocusOnTab: !browserWindow.platformIsMac
                    style: ButtonStyle {
                        background: Rectangle {
                            implicitWidth: 24
                            implicitHeight: 24
                            color: "white"
                            radius: 12
                        }
                    }
                }
                ToolButton {
                    id: menuButton
                    iconSource: "icons/menu_16.png"
//                    onClicked: onClickMenuButtion()
                    activeFocusOnTab: !browserWindow.platformIsMac
                    style: ButtonStyle {
                        background: Rectangle {
                            implicitWidth: 24
                            implicitHeight: 24
                            color: "white"
                            radius: 12
                        }
                    }
                }
                ToolButton {
                    id: fullscreenButton
                    iconSource: "icons/full_screen_16.png"
                    onClicked: navigationBar.onClickFullScreen()
                    activeFocusOnTab: !browserWindow.platformIsMac
                    style: ButtonStyle {
                        background: Rectangle {
                            implicitWidth: 24
                            implicitHeight: 24
                            color: "white"
                            radius: 12
                        }
                    }
                }

            }

            function onClickFullScreen() {
                console.log('>>> onClickFullScreen')
                tabs.visible = false
                navigationBar.visible = false
            }
    }

    TabView {
        id: tabs
        anchors.fill: parent
        Component.onCompleted: {
            createEmptyTab()
            createAddTab()
        }

        style: TabViewStyle {
            frameOverlap: 1
            frame: Rectangle { color: "black" }
            tabBar: Rectangle { color: "black"; anchors.fill: parent }
            tabOverlap: -20
            tabsAlignment: Qt.AlignLeft
            padding.left: 2
            tab: Rectangle {
                anchors.leftMargin: 5
                anchors.rightMargin: 10
                property color frameColor: "black"
                property color fillColor: "black"
                color: "black"
//                implicitWidth: styleData.index === (tabs.count -1 ) ? 30 :Math.max(text.width + 4, 200)
                implicitWidth: styleData.index === (tabs.count -1 ) ? 30 : 200
                implicitHeight: 30
                border.width: 1
                border.color: "red"
                BorderImage {
                    id: borderImage
                    source: styleData.index === tabs.currentIndex ? "icons/top_border.png" : "icons/top_gray_border.png"
                    width: parent.width
                    height: 30
                    border.left: 0;
                    border.top: 2
                    border.right: 0;
                    border.bottom: 0;
                }
                Image {
                    anchors.left: parent.left
                    anchors.leftMargin: 2
                    anchors.verticalCenter: parent.verticalCenter;
                    visible: styleData.index === (tabs.count -1 ) ? false:true
                    x: 1
                    z: 1
                    id: tabImage
                    width: 16;
                    height: 16
                    source: {
                        console.log('>> Image currentWebView:'+currentWebView)
                        if (currentWebView !== null && currentWebView.icon !== null && styleData.index === tabs.currentIndex)
                            currentWebView.icon
                    }
                }

                Text {
                    id: text
                    width: 180
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    anchors.verticalCenter: parent.verticalCenter;
                    visible: styleData.index === (tabs.count -1 ) ? false:true
                    elide : Text.ElideRight
                    text: {
                        console.log('>> Text currentWebView:'+currentWebView)
                        console.log('>> Text currentWebView.url:'+currentWebView.url)
                        if (currentWebView === null || currentWebView.url === null)
                            "New Tab"
                        else
                            if (styleData.index === tabs.currentIndex)
                                currentWebView.url
                    }
                    color: "white"
                }
                Button {
                    id: addButton
                    iconSource: styleData.index === (tabs.count -1 ) ? "icons/plus.png" : "icons/close.png"
                    visible: styleData.index === 0 ? false : true
                    activeFocusOnTab: styleData.index === (tabs.count -1 ) ? 30 :Math.max(text.width + 4, 200)
                    implicitHeight: 30
                    anchors.right: parent.right
                    anchors.rightMargin: 0
                    anchors.leftMargin: 2
                    anchors.verticalCenter: tabs.verticalCenter;
                    BorderImage {
                        id: buttonborderImage
                        source: styleData.index === tabs.currentIndex ? "icons/top_border.png" : "icons/top_gray_border.png"
                        width: parent.width
                        height: 30
                        border.left: 0;
                        border.top: 2
                        border.right: 0;
                        border.bottom: 0
                    }
                    style: ButtonStyle {
                        background: Rectangle {
                            implicitWidth: 12
                            implicitHeight: 12
                            color: "black"
                        }
                    }
                    onClicked: {
                        styleData.index === (tabs.count -1 ) ? tabs.clickAddButton() : tabs.clickCloseButton(styleData.index)
                    }
                }
            }

        }

        Component {
            id: tabComponent
            WebEngineView {
                id: webEngineView
                focus: true
                onLinkHovered: {
                    if (hoveredUrl == "")
                        resetStatusText.start()
                    else {
                        resetStatusText.stop()
                        statusText.text = hoveredUrl
                        console.log('statusText.text >> ' + statusText.text)
                    }
                }
            }
        }
        Component {
            id: tabAddComponent
            Rectangle {
                color: "white"
                implicitWidth: 100
            }

//            WebEngineView {
//                id: addWebEngineView
//                focus: false
//                onClipChanged: {
//                    console.log(">>> onClipChanged")
//                }
//            }
        }

        function clickCloseButton(index) {
            console.log(">>> clickCloseButton at index:"+index)
            tabs.removeTab(index)
            tabs.currentIndex = index-1
        }

        function clickAddButton() {
            console.log("clickAddButton")
            tabs.insertEmptyTab()
        }


        function isLastTab() {
            console.log("tabs.tabPosition ="+tabs.tabPosition())
            return true
        }

        function createEmptyTab() {
            var tabsCount = tabs.count
            console.log('>>> createEmptyTab tabsCount:'+tabsCount)
            var tab = addTab("New tab", tabComponent)
            // We must do this first to make sure that tab.active gets set so that tab.item gets instantiated immediately.
            tabs.currentIndex = tabs.count - 1
            console.log('tabs.tabPosition: ' + tabs.tabPosition)
//            tab.title = Qt.binding(function() { return tab.item.title })
            tab.title = "New Tab"

            return tab
        }

        function insertEmptyTab() {
            var pos = tabs.count - 1
            console.log('>>> insertEmptyTab  pos:'+pos)
            var tab = insertTab(pos, "New tab", tabComponent)
            // We must do this first to make sure that tab.active gets set so that tab.item gets instantiated immediately.
            tabs.currentIndex = pos
            tab.title = "New Tab"
            return tab
        }


        function createAddTab() {
            var tabsCount = tabs.count
            console.log('>>> createAddTab tabsCount:'+tabsCount)
            var tab = addTab("", tabAddComponent)
            if (tabs.count >= 2) {
                tabs.currentIndex = tabs.count - 2
            }

            var last = tabs.count-1;
            console.log('last: ' + last)
            console.log('tabs.tabPosition: ' + tabs.tabPosition)
            console.log('Current tab: ' + tabs.getTab(last).item);
            console.log('tab: ' + tab.item);
            tab.active = true;
            tab.icon =  "icons/close.png";
            console.log('>>> createAddTab:' + tabs.currentIndex);
            console.log('>>> createAddTab:' + tabs.getTab(last));
            return tab
        }
    }

    Rectangle {
        id: statusBubble
        color: "oldlace"
        property int padding: 8

        anchors.left: parent.left
        anchors.bottom: parent.bottom
        width: statusText.paintedWidth + padding
        height: statusText.paintedHeight + padding

        Text {
            id: statusText
            anchors.centerIn: statusBubble
            elide: Qt.ElideMiddle

            Timer {
                id: resetStatusText
                interval: 750
                onTriggered: statusText.text = ""
            }
        }
    }
}
