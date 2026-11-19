import QtQuick
import QtQuick.Effects

// Circle with the contact's photo, or their initials until a photo loads.
// The photo is masked to a circle on GPU scene graphs; the software renderer
// can't run shader effects, so there it's shown clipped to the square.
Rectangle {
    id: avatar
    property string source: ""
    property string initials: ""
    property int fontPixelSize: 14
    readonly property bool hasPhoto: photo.status === Image.Ready
    readonly property bool canMask: GraphicsInfo.api !== GraphicsInfo.Software

    radius: width / 2
    clip: !canMask

    Text {
        anchors.centerIn: parent
        text: avatar.initials
        font.pixelSize: avatar.fontPixelSize
        font.bold: true
        color: "#ffffff"
        visible: !avatar.hasPhoto
    }

    Image {
        id: photo
        objectName: "avatarPhoto"
        anchors.fill: parent
        source: avatar.source
        sourceSize.width: Math.ceil(avatar.width * 2)
        sourceSize.height: Math.ceil(avatar.height * 2)
        asynchronous: true
        autoTransform: true
        fillMode: Image.PreserveAspectCrop
        visible: avatar.hasPhoto && !avatar.canMask
    }

    MultiEffect {
        anchors.fill: photo
        source: photo
        visible: avatar.hasPhoto && avatar.canMask
        maskEnabled: true
        maskSource: circleMask
    }

    Item {
        id: circleMask
        anchors.fill: parent
        layer.enabled: true
        visible: false
        Rectangle {
            anchors.fill: parent
            radius: width / 2
        }
    }
}
