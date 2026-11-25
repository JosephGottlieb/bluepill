import QtQuick

// Circle with the contact's photo, or their initials until a photo loads.
// The photo is masked to a circle on GPU scene graphs when QtQuick.Effects is
// available; on software renderers or older Qt (<6.5), it clips to the box.
Rectangle {
    id: avatar
    property string source: ""
    property string initials: ""
    property int fontPixelSize: 14
    readonly property bool hasPhoto: photo.status === Image.Ready
    readonly property bool canMask: GraphicsInfo.api !== GraphicsInfo.Software
    readonly property Component maskComponent: {
        if (!canMask) return null
        var c = Qt.createComponent("RoundedCornerMask.qml")
        return c.status === Component.Ready ? c : null
    }
    readonly property bool hasEffectMask: maskComponent !== null

    radius: width / 2
    clip: !canMask || !hasEffectMask

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
        property real radius: Math.min(width, height) / 2
        source: avatar.source
        sourceSize.width: Math.ceil(avatar.width * 2)
        sourceSize.height: Math.ceil(avatar.height * 2)
        asynchronous: true
        autoTransform: true
        fillMode: Image.PreserveAspectCrop
        visible: avatar.hasPhoto
        layer.enabled: avatar.hasPhoto && avatar.canMask && avatar.hasEffectMask
        layer.effect: avatar.maskComponent
    }
}
