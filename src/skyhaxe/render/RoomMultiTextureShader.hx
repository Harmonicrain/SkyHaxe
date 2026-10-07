package skyhaxe.render;

#if (js && html5 && skyhaxe_room_batch)
import openfl.display.Shader;

/**
 * Small WebGL1-compatible shader for the opt-in room batcher. Eight explicit
 * samplers avoid unsupported dynamic sampler-array indexing on WebGL1.
 */
class RoomMultiTextureShader extends Shader {
    @:glVertexHeader("attribute float openfl_Alpha;
        attribute vec4 openfl_ColorMultiplier;
        attribute vec4 openfl_ColorOffset;
        attribute vec4 openfl_Position;
        attribute vec2 openfl_TextureCoord;
        attribute float room_TextureId;

        varying float openfl_Alphav;
        varying vec4 openfl_ColorMultiplierv;
        varying vec4 openfl_ColorOffsetv;
        varying vec2 openfl_TextureCoordv;
        varying float room_TextureIdv;

        uniform mat4 openfl_Matrix;
        uniform bool openfl_HasColorTransform;")
    @:glVertexBody("openfl_Alphav = openfl_Alpha;
        openfl_TextureCoordv = openfl_TextureCoord;
        openfl_ColorMultiplierv = openfl_ColorMultiplier;
        openfl_ColorOffsetv = openfl_ColorOffset / 255.0;
        room_TextureIdv = room_TextureId;
        gl_Position = openfl_Matrix * openfl_Position;")
    @:glVertexSource("#pragma header
        void main(void) {
            #pragma body
        }")
    @:glFragmentHeader("varying float openfl_Alphav;
        varying vec4 openfl_ColorMultiplierv;
        varying vec4 openfl_ColorOffsetv;
        varying vec2 openfl_TextureCoordv;
        varying float room_TextureIdv;

        uniform bool openfl_HasColorTransform;
        uniform sampler2D room_Texture0;
        uniform sampler2D room_Texture1;
        uniform sampler2D room_Texture2;
        uniform sampler2D room_Texture3;
        uniform sampler2D room_Texture4;
        uniform sampler2D room_Texture5;
        uniform sampler2D room_Texture6;
        uniform sampler2D room_Texture7;")
    @:glFragmentBody("vec4 color;
        // Ids above 31 mark ADD sprites folded into a NORMAL run (see RoomBitmapBatch).
        float textureId = room_TextureIdv;
        bool additive = textureId > 31.5;
        if (additive) textureId -= 32.0;
        if (textureId < 0.5) color = texture2D(room_Texture0, openfl_TextureCoordv);
        else if (textureId < 1.5) color = texture2D(room_Texture1, openfl_TextureCoordv);
        else if (textureId < 2.5) color = texture2D(room_Texture2, openfl_TextureCoordv);
        else if (textureId < 3.5) color = texture2D(room_Texture3, openfl_TextureCoordv);
        else if (textureId < 4.5) color = texture2D(room_Texture4, openfl_TextureCoordv);
        else if (textureId < 5.5) color = texture2D(room_Texture5, openfl_TextureCoordv);
        else if (textureId < 6.5) color = texture2D(room_Texture6, openfl_TextureCoordv);
        else color = texture2D(room_Texture7, openfl_TextureCoordv);

        // Per-sprite equivalent of OpenFL's ColorTransform.__isDefault(true): only sprites with a
        // real transform take the unpremultiply path, so untransformed sprites match OpenFL exactly.
        if (color.a == 0.0) {
            gl_FragColor = vec4(0.0);
        } else if (openfl_HasColorTransform && (any(notEqual(openfl_ColorMultiplierv.rgb, vec3(1.0)))
                || any(notEqual(openfl_ColorOffsetv, vec4(0.0))))) {
            color = vec4(color.rgb / color.a, color.a);
            color = clamp(openfl_ColorOffsetv
                + vec4(color.rgb * openfl_ColorMultiplierv.rgb, color.a), 0.0, 1.0);
            gl_FragColor = color.a > 0.0
                ? vec4(color.rgb * color.a * openfl_Alphav, color.a * openfl_Alphav)
                : vec4(0.0);
        } else {
            gl_FragColor = color * openfl_Alphav;
        }

        if (additive) gl_FragColor.a = 0.0;")
    @:glFragmentSource("#pragma header
        void main(void) {
            #pragma body
        }")
    public function new() {
        super();
    }
}
#end
