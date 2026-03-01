import QtQuick 2.15
import SddmComponents 2.0

Rectangle {
    id: root
    width: 1920
    height: 1080
    color: "#030812"

    property int sessionIndex: session.index

    TextConstants { id: textConstants }

    Connections {
        target: sddm

        function onLoginSucceeded() {
            feedback.color = "#9fd0ff"
            feedback.text = textConstants.loginSucceeded
        }

        function onLoginFailed() {
            password.text = ""
            feedback.color = "#ff9ab0"
            feedback.text = textConstants.loginFailed
        }

        function onInformationMessage(message) {
            feedback.color = "#ff9ab0"
            feedback.text = message
        }
    }

    Image {
        id: wallpaper
        anchors.fill: parent
        source: config.background
        fillMode: Image.PreserveAspectCrop
    }

    Rectangle {
        anchors.fill: parent
        color: "#66020a18"
    }

    Rectangle {
        id: card
        anchors.centerIn: parent
        width: 440
        radius: 18
        color: "#d60b1a35"
        border.width: 1
        border.color: "#669ad0ff"
    }

    Column {
        id: form
        anchors.fill: card
        anchors.margins: 26
        spacing: 12

        Text {
            text: "System Login"
            color: "#d8e9ff"
            font.pixelSize: 28
            font.bold: true
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Text {
            text: Qt.formatDateTime(new Date(), "dddd, MMMM d")
            color: "#9bb7df"
            font.pixelSize: 14
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Rectangle {
            width: parent.width
            height: 38
            radius: 10
            color: "#203353"
            border.width: 1
            border.color: "#4e78ab"

            TextBox {
                id: name
                anchors.fill: parent
                anchors.margins: 8
                text: userModel.lastUser
                font.pixelSize: 14

                KeyNavigation.tab: password
                Keys.onPressed: function(event) {
                    if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                        sddm.login(name.text, password.text, root.sessionIndex)
                        event.accepted = true
                    }
                }
            }
        }

        Rectangle {
            width: parent.width
            height: 38
            radius: 10
            color: "#203353"
            border.width: 1
            border.color: "#4e78ab"

            PasswordBox {
                id: password
                anchors.fill: parent
                anchors.margins: 8
                font.pixelSize: 14

                KeyNavigation.backtab: name
                KeyNavigation.tab: session
                Keys.onPressed: function(event) {
                    if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                        sddm.login(name.text, password.text, root.sessionIndex)
                        event.accepted = true
                    }
                }
            }
        }

        Rectangle {
            width: parent.width
            height: 36
            radius: 10
            color: "#1a2a45"
            border.width: 1
            border.color: "#466e9e"

            ComboBox {
                id: session
                anchors.fill: parent
                anchors.margins: 6
                model: sessionModel
                index: sessionModel.lastIndex
                font.pixelSize: 13
                KeyNavigation.backtab: password
                KeyNavigation.tab: loginButton
            }
        }

        Text {
            id: feedback
            width: parent.width
            text: textConstants.prompt
            color: "#9bb7df"
            font.pixelSize: 12
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
        }

        Row {
            width: parent.width
            spacing: 8

            Button {
                id: loginButton
                text: textConstants.login
                width: (parent.width - 16) / 3
                onClicked: sddm.login(name.text, password.text, root.sessionIndex)
            }

            Button {
                text: textConstants.shutdown
                width: (parent.width - 16) / 3
                onClicked: sddm.powerOff()
            }

            Button {
                text: textConstants.reboot
                width: (parent.width - 16) / 3
                onClicked: sddm.reboot()
            }
        }
    }

    Component.onCompleted: password.forceActiveFocus()
}
