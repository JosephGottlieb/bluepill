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
    property bool hasEffectMask: false

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
        source: avatar.source
        sourceSize.width: Math.ceil(avatar.width * 2)
        sourceSize.height: Math.ceil(avatar.height * 2)
        asynchronous: true
        autoTransform: true
        fillMode: Image.PreserveAspectCrop
        visible: avatar.hasPhoto && (!avatar.canMask || !avatar.hasEffectMask)
    }

    Item {
        id: effectHost
        anchors.fill: photo
        visible: avatar.hasPhoto && avatar.canMask && avatar.hasEffectMask
        Component.onCompleted: {
            if (!avatar.canMask) return
            try {
                var fx = Qt.createQmlObject(
                    'import QtQuick; import QtQuick.Effects; MultiEffect { anchors.fill: parent; maskEnabled: true }',
                    effectHost,
                    "RoundAvatarEffect"
                )
                if (fx) {
                    fx.source = photo
                    fx.maskSource = circleMask
                    avatar.hasEffectMask = true
                }
            } catch (e) {
                avatar.hasEffectMask = false
            }
        }
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
