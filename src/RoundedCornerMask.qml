import QtQuick
import QtQuick.Effects

// layer.effect for inline images: clips the layer to a rounded rectangle.
// The radius comes from the layered item's own `radius` property.
MultiEffect {
    id: fx
    // As a layer.effect, `source` is a ShaderEffectSource whose sourceItem is
    // the layered item, so read its radius from there.
    readonly property var layerSource: source
    readonly property real cornerRadius: (layerSource && layerSource.sourceItem && layerSource.sourceItem.radius !== undefined)
                                         ? layerSource.sourceItem.radius : 12
    maskEnabled: true
    maskThresholdMin: 0.5
    maskSpreadAtMin: 1.0
    maskSource: ShaderEffectSource {
        id: maskTexture
        sourceItem: maskShape
        hideSource: true
        live: false
    }

    onWidthChanged: maskTexture.scheduleUpdate()
    onHeightChanged: maskTexture.scheduleUpdate()
    onCornerRadiusChanged: maskTexture.scheduleUpdate()
    Component.onCompleted: maskTexture.scheduleUpdate()

    Rectangle {
        id: maskShape
        width: fx.width
        height: fx.height
        radius: fx.cornerRadius
        antialiasing: true
        color: "black"
        visible: false
    }
}
