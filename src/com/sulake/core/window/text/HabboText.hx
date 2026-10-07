package com.sulake.core.window.text;

import js.Browser;
import js.lib.Promise;
import openfl.display.BitmapData;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
import openfl.geom.ColorTransform;

/** Browser boundary for the pinned Habbo HTML5 AIR51 font engine. */
@:access(openfl.text.TextField)
@:access(openfl.text._internal.TextEngine)
@:access(lime.graphics.ImageBuffer)
class HabboText {
    public static var instance(default, null):Null<HabboText>;
    static var pending:Promise<Dynamic>;
    final api:Dynamic;

    function new(api:Dynamic) this.api = api;

    public static function load(base:String, styles:Array<String>, onReady:Void->Void, onError:Dynamic->Void):Void {
        if (instance != null) { onReady(); return; }
        if (pending == null) {
            var importModule:String->Promise<Dynamic> = js.Syntax.code("new Function('u', 'return import(u)')");
            pending = importModule(base + "/text.mjs").then(function(module:Dynamic) return module.load(base))
                .then(function(engine:Dynamic) {
                    instance = new HabboText(engine);
                    #if debug
                    js.Syntax.code("window.__skyhaxeText = {0}", engine);
                    #end
                    return engine;
                });
        }
        pending.then(function(_) { onReady(); return null; }).catchError(function(error:Dynamic) {
            pending = null; onError(error);
        });
    }

    static function ready():HabboText {
        if (instance == null) throw new haxe.Exception("Text requested before HabboText.load completed");
        return instance;
    }

    public static function handles(family:String):Bool {
        if (family == null) return false;
        var name = StringTools.replace(family, " ", "").toLowerCase();
        return StringTools.startsWith(name, "ubuntu") || StringTools.startsWith(name, "volter");
    }

    public static function fontHasGlyphs(font:openfl.text.Font, text:String):Bool {
        if (font == null || text == null) throw new haxe.Exception("Font.hasGlyphs requires a font and text");
        if (text == "" || !handles(font.fontName)) return true;
        return ready().api.hasGlyphs({fontFamily: font.fontName,
            bold: font.fontStyle == openfl.text.FontStyle.BOLD || font.fontStyle == openfl.text.FontStyle.BOLD_ITALIC,
            italic: font.fontStyle == openfl.text.FontStyle.ITALIC || font.fontStyle == openfl.text.FontStyle.BOLD_ITALIC}, text);
    }

    /** Flash's stage quality is global: an off-stage field drawn into a BitmapData renders at the
        stage's quality, which the Habbo client sets to LOW. Normal-antialiased Volter only rasterizes
        crisp at LOW; at HIGH the native engine supersamples it into soft edges. */
    static function lowQuality(field:TextField):Bool {
        var stage = field != null && field.stage != null ? field.stage : openfl.Lib.current.stage;
        return stage != null && stage.quality == openfl.display.StageQuality.LOW;
    }

    /** Habbo HTML5's TextField starts at advanced; only an explicit "normal" opts out. */
    static function isAdvanced(field:TextField):Bool {
        return field == null || field.antiAliasType != openfl.text.AntiAliasType.NORMAL;
    }

    public static function openFLStyle(field:TextField, format:TextFormat):Dynamic {
        var family = format.font;
        // Flash's default face is unavailable in the embedded registry. Use a deterministic face
        // for unformatted measurement fields (notably the friend-bar name cropper).
        if (family == null || family.toLowerCase() == "times new roman") family = "Ubuntu";
        var advanced = isAdvanced(field);
        // The AIR51 profiles are pixel grid-fitted, and the native renderer accepts advanced text only
        // at "pixel". Habbo HTML5 itself sends its 125 subpixel layout fields to Canvas; SkyHaxe
        // keeps every advanced run on the native renderer instead, so it renders those at pixel.
        return {fontFamily: family, fontSize: format.size == null ? 12 : format.size,
            color: format.color == null ? 0 : format.color, bold: format.bold == true, italic: format.italic == true,
            antiAliasType: advanced ? "advanced" : "normal",
            gridFitType: advanced || field.gridFitType == null ? "pixel" : Std.string(field.gridFitType),
            sharpness: advanced && field != null ? field.sharpness : 0,
            thickness: advanced && field != null ? field.thickness : 0,
            kerning: format.kerning == true, letterSpacing: format.letterSpacing == null ? 0 : format.letterSpacing,
            leading: format.leading == null ? 0 : format.leading,
            stageQuality: lowQuality(field) ? "low" : "high"};
    }

    public static function openFLPositions(field:TextField, format:TextFormat, text:String):Array<Float> {
        return text == "" ? [] : ready().api.advances(text, openFLStyle(field, format));
    }

    public static function openFLMetrics(field:TextField, format:TextFormat):Dynamic {
        return ready().api.metrics(openFLStyle(field, format));
    }

    public static function drawOpenFLRun(field:TextField, context:js.html.CanvasRenderingContext2D,
            format:TextFormat, text:String, x:Float, baseline:Float):Void {
        if (text == "") return;
        var style = openFLStyle(field, format);
        var fill = Std.string(context.fillStyle);
        if (fill.charAt(0) == "#") style.color = Std.parseInt("0x" + fill.substring(1));
        ready().api.draw(context, text, x, baseline, style);
    }

    /** Retained compositing at BitmapData.draw, before OpenFL creates a transparent text texture.
        Complex transforms, masks, filters, input selections and device-font runs use ordinary OpenFL. */
    public static function drawToBitmap(target:BitmapData, field:TextField, matrix:Matrix,
            color:ColorTransform, blend:openfl.display.BlendMode, clip:Rectangle):Bool {
        if (instance == null || !target.readable || target.image == null || field.type == openfl.text.TextFieldType.INPUT
            || !isAdvanced(field) || field.background || field.border
            || field.mask != null || field.scrollRect != null || field.filters.length != 0
            || field.alwaysShowSelection || (field.stage != null && field.stage.focus == field)
            || (blend != null && blend != openfl.display.BlendMode.NORMAL)) return false;
        var tx = matrix == null ? 0.0 : matrix.tx;
        var ty = matrix == null ? 0.0 : matrix.ty;
        if ((matrix != null && (matrix.a != 1 || matrix.d != 1 || matrix.b != 0 || matrix.c != 0))
            || Math.floor(tx) != tx || Math.floor(ty) != ty) return false;
        field.__updateLayout();
        var engine = field.__textEngine;
        var text = engine.text;
        if (text == null || text == "") return true;
        var scrollY = 0.0;
        for (i in 0...field.scrollV - 1) scrollY -= engine.lineHeights[i];
        var runs:Array<Dynamic> = [];
        for (group in engine.layoutGroups) {
            if (group.lineIndex < field.scrollV - 1 || group.lineIndex > engine.bottomScrollV - 1) continue;
            var style = openFLStyle(field, group.format);
            if (group.format.underline) return false; // OpenFL owns underline geometry.
            if (color != null) style.colorTransform = {redMultiplier: color.redMultiplier, greenMultiplier: color.greenMultiplier,
                blueMultiplier: color.blueMultiplier, alphaMultiplier: color.alphaMultiplier, redOffset: color.redOffset,
                greenOffset: color.greenOffset, blueOffset: color.blueOffset, alphaOffset: color.alphaOffset};
            runs.push({text: text.substring(group.startIndex, group.endIndex), style: style,
                x: tx + group.offsetX - field.scrollH,
                baseline: ty + group.offsetY + group.ascent + scrollY});
        }
        var left = Math.max(0, tx), top = Math.max(0, ty);
        var right = Math.min(target.width, tx + field.width), bottom = Math.min(target.height, ty + field.height);
        if (clip != null) {
            left = Math.max(left, clip.x); top = Math.max(top, clip.y);
            right = Math.min(right, clip.right); bottom = Math.min(bottom, clip.bottom);
        }
        lime._internal.graphics.ImageCanvasUtil.convertToCanvas(target.image);
        var context:js.html.CanvasRenderingContext2D = cast target.image.buffer.__srcContext;
        if (!instance.api.drawRetained(context, runs, {x: left, y: top, right: right, bottom: bottom})) return false;
        target.image.buffer.__srcImageData = null;
        target.image.buffer.data = null;
        target.image.dirty = true; target.image.version++;
        return true;
    }

    public function measureWidth(text:String, style:Dynamic, ?opts:Dynamic):Float {
        return measureField(text, style, opts).textWidth;
    }
    public function measureHeight(text:String, style:Dynamic, ?opts:Dynamic):Float {
        return measureField(text, style, opts).textHeight;
    }
    public function render(text:String, style:Dynamic, ?opts:Dynamic):Null<BitmapData> {
        if (text == "") return null;
        var field = measureField(text, style, opts);
        var bitmap = new BitmapData(Std.int(Math.max(1, Math.ceil(field.width))), Std.int(Math.max(1, Math.ceil(field.height))), true, 0);
        bitmap.draw(field);
        return bitmap;
    }
    function measureField(text:String, style:Dynamic, opts:Dynamic):TextField {
        var field = new TextField();
        var format = new TextFormat(style.fontFamily, style.fontSize, style.color, style.bold, style.italic,
            style.underline, null, null, null, null, null, style.leading);
        format.kerning = style.kerning;
        format.letterSpacing = style.letterSpacing == null ? 0 : style.letterSpacing;
        field.defaultTextFormat = format;
        field.antiAliasType = cast style.antiAliasType;
        field.gridFitType = cast style.gridFitType;
        field.sharpness = style.sharpness; field.thickness = style.thickness;
        field.autoSize = openfl.text.TextFieldAutoSize.LEFT;
        if (opts != null && opts.wordWrap == true) { field.wordWrap = true; field.width = opts.width; }
        field.text = text;
        return field;
    }
    public static function style(name:String, color:Int, ?size:Null<Int>):Dynamic {
        var source = com.sulake.core.window.utils.TextStyleManager.getStyle(name);
        if (source == null) throw new haxe.Exception('Unknown text style: $name');
        return {fontFamily: source.fontFamily, fontSize: size != null ? size : Std.parseInt(Std.string(source.fontSize)),
            color: color, bold: source.fontWeight == "bold", italic: source.fontStyle == "italic",
            antiAliasType: source.antiAliasType == null ? "normal" : source.antiAliasType, gridFitType: "pixel",
            sharpness: source.sharpness == null ? 0 : Std.parseFloat(Std.string(source.sharpness)),
            thickness: source.thickness == null ? 0 : Std.parseFloat(Std.string(source.thickness)),
            kerning: source.kerning == true || Std.string(source.kerning) == "true",
            leading: source.leading == null ? 0 : Std.parseInt(Std.string(source.leading))};
    }
}
