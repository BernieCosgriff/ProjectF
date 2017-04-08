
attribute vec2 position;
uniform vec2 translate;

attribute vec4 color;
varying vec4 colorInterpolated;

attribute vec2 textCoord;
varying vec2 textCoordInterpolated;

void main() {
    gl_Position = vec4(position.x + translate.x, position.y + translate.y, 0.0, 1.0);
    colorInterpolated = color;
    textCoordInterpolated = textCoord;
}
