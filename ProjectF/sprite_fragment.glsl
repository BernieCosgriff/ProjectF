
varying highp vec4 colorInterpolated;
varying highp vec2 textCoordInterpolated;

uniform sampler2D textureUnit;

void main() {
    gl_FragColor = texture2D(textureUnit, textCoordInterpolated);
}
