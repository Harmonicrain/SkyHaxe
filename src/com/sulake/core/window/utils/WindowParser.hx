package com.sulake.core.window.utils;

import com.sulake.core.localization.Localization;
import com.sulake.core.utils.xml.XML;
import com.sulake.core.window.WindowController;
import com.sulake.core.window.graphics.WindowSkinRenderer;
import com.sulake.core.window.theme.ElementDescription;
import com.sulake.core.window.theme.InternalLayouts;
import haxe.ds.StringMap;
import openfl.filters.BitmapFilter;
import openfl.filters.DropShadowFilter;

/**
 * Explicit Haxe rewrite of the structural part of AS3 WindowParser.
 * E4X member/property access is replaced with the G1d XML compatibility API.
 */
class WindowParser {
    final skinRenderer:Null<WindowSkinRenderer>;

    public function new(?skinRenderer:WindowSkinRenderer) {
        this.skinRenderer = skinRenderer;
        // A control's internal children come from the theme, so the controller needs a way to
        // build them without knowing about the parser. Handing it a factory keeps that one-way.
        WindowController.internalBuilder = buildInternalChildren;
    }

    /**
     * Instantiate a control's internal child windows from its theme entry.
     *
     * `habbo_element_description_xml.bin` maps (type, style) to a `window_layout`, and that
     * document declares the children -- `_BTN_TEXT`, `_TITLE`, `_CONTENT` and friends -- with the
     * tags, params, text styles and margins that give the control its appearance. Nothing here is
     * control-specific: buttons, frames, headers and dropmenus all resolve the same way.
     */
    function buildInternalChildren(typeName:String, style:Int):Array<WindowController> {
        var entry = ElementDescription.find(typeName, style);
        if (entry == null) return [];
        var layout = InternalLayouts.find(entry.windowLayout);
        if (layout == null) return [];
        var built:Array<WindowController> = [];
        for (windowNode in layout.child("window")) {
            // Internal children inherit the host's style unless they declare their own. A frame_3
            // declares `<header name="titlebar">` with no style; without inheritance that resolves
            // to header style 0 -- a different skin, a different internal layout, and a title bar
            // that renders nothing.
            for (child in windowNode.children()) built.push(parseEntity(child, style));
        }
        return built;
    }

    public function parseLayout(xml:XML):WindowController {
        if (xml.localName() != "layout") {
            throw new haxe.Exception('Expected <layout>, got <${xml.localName()}>');
        }
        var width = numberAttribute(xml, "width", 0);
        var height = numberAttribute(xml, "height", 0);
        var root = new WindowController(
            "layout",
            stringAttribute(xml, "name", ""),
            "",
            0,
            0,
            0,
            0,
            0,
            width,
            height,
            true,
            parseVariables(xml), null, null, null, null, skinRenderer,
            intAttribute(xml, "color", 0xFFFFFF),
            stringAttribute(xml, "background", "false") == "true"
        );
        var windowNodes = xml.child("window");
        if (windowNodes.length() == 0) throw new haxe.Exception("Layout contains no <window> node");
        for (windowNode in windowNodes) {
            for (entity in windowNode.children()) root.addWindowChild(parseEntity(entity));
        }
        root.finalizeLayout();
        return root;
    }

    private function parseEntity(xml:XML, inheritedStyle:Int = -1):WindowController {
        var typeName = xml.localName();
        if (typeName == null || typeName == "") throw new haxe.Exception("Window entity has no element name");
        var declaredStyle = optionalNumberAttribute(xml, "style");
        var style = declaredStyle != null ? Std.int(declaredStyle)
            : inheritedStyle >= 0 ? inheritedStyle : 0;
        var controller = new WindowController(
            typeName,
            decode(stringAttribute(xml, "name", "")),
            // Captions are authored as `${key}` tokens against the hotel's text table.
            Localization.resolve(decode(stringAttribute(xml, "caption", ""))),
            style,
            intAttribute(xml, "params", 0) | namedParams(xml),
            intAttribute(xml, "id", 0),
            numberAttribute(xml, "x", 0),
            numberAttribute(xml, "y", 0),
            numberAttribute(xml, "width", 0),
            numberAttribute(xml, "height", 0),
            stringAttribute(xml, "visible", "true") == "true",
            parseVariables(xml),
            optionalNumberAttribute(xml, "width_min"),
            optionalNumberAttribute(xml, "width_max"),
            optionalNumberAttribute(xml, "height_min"),
            optionalNumberAttribute(xml, "height_max"),
            skinRenderer,
            intAttribute(xml, "color", 0xFFFFFF),
            stringAttribute(xml, "background", "false") == "true"
        );
        applyFilters(xml, controller);
        var groups = xml.child("children");
        if (groups.length() > 0) {
            for (child in groups.at(0).children()) {
                controller.addWindowChild(parseEntity(child, inheritedStyle));
            }
        }
        return controller;
    }

    /**
     * Internal layouts spell their params out by name; application layouts pack them into an
     * integer. Both have to produce the same mask.
     */
    private static function namedParams(xml:XML):Int {
        var groups = xml.child("params");
        if (groups.length() == 0) return 0;
        var names:Array<String> = [];
        for (param in groups.at(0).children()) {
            if (param.localName() != "param") continue;
            var name = stringAttribute(param, "name", "");
            if (name != "") names.push(name);
        }
        return ParamCodeTable.mask(names);
    }

    private function applyFilters(xml:XML, controller:WindowController):Void {
        var groups = xml.child("filters");
        if (groups.length() == 0) return;
        var filters:Array<BitmapFilter> = [];
        for (filter in groups.at(0).children()) {
            if (filter.localName() != "DropShadowFilter") continue;
            filters.push(new DropShadowFilter(
                numberAttribute(filter, "distance", 0),
                numberAttribute(filter, "angle", 45),
                intAttribute(filter, "color", 0),
                numberAttribute(filter, "alpha", 1),
                numberAttribute(filter, "blurX", 0),
                numberAttribute(filter, "blurY", 0),
                numberAttribute(filter, "strength", 1),
                intAttribute(filter, "quality", 1),
                stringAttribute(filter, "inner", "false") == "true",
                stringAttribute(filter, "knockout", "false") == "true",
                stringAttribute(filter, "hideObject", "false") == "true"
            ));
        }
        if (filters.length > 0) controller.filters = filters;
    }

    private function parseVariables(xml:XML):StringMap<Dynamic> {
        var result = new StringMap<Dynamic>();
        var tags = stringAttribute(xml, "tags", "");
        if (tags != "") result.set("__tags", tags);
        var groups = xml.child("variables");
        if (groups.length() == 0) return result;
        for (variable in groups.at(0).children()) {
            if (variable.localName() != "var") continue;
            var key = stringAttribute(variable, "key", "");
            var value = stringAttribute(variable, "value", "");
            // `margins` is a nested Map rather than a flat value:
            //   <var key="margins"><value><Map><var key="left" value="10" type="int"/>...
            // Flattened to margin_left / margin_top / ... so callers stay simple.
            if (key == "margins") {
                for (holder in variable.children()) {
                    for (map in holder.children()) {
                        for (edge in map.children()) {
                            if (edge.localName() != "var") continue;
                            result.set("margin_" + stringAttribute(edge, "key", ""),
                                Std.parseFloat(stringAttribute(edge, "value", "0")));
                        }
                    }
                }
                continue;
            }
            var type = stringAttribute(variable, "type", "String").toLowerCase();
            result.set(key, switch (type) {
                case "boolean": value.toLowerCase() == "true" || value == "1";
                case "int", "uint": Std.parseInt(value);
                case "number", "float": Std.parseFloat(value);
                case "hex": Std.parseInt(value);
                default: value;
            });
        }
        return result;
    }

    private static function stringAttribute(xml:XML, name:String, fallback:String):String {
        var value = xml.attribute(name);
        return value.length() == 0 ? fallback : value.toString();
    }

    private static function numberAttribute(xml:XML, name:String, fallback:Float):Float {
        var raw = stringAttribute(xml, name, Std.string(fallback));
        var parsed = Std.parseFloat(raw);
        return Math.isNaN(parsed) ? fallback : parsed;
    }

    private static function optionalNumberAttribute(xml:XML, name:String):Null<Float> {
        if (xml.attribute(name).length() == 0) return null;
        var parsed = Std.parseFloat(xml.attribute(name).toString());
        return Math.isNaN(parsed) ? null : parsed;
    }

    private static function intAttribute(xml:XML, name:String, fallback:Int):Int {
        var parsed = Std.parseInt(stringAttribute(xml, name, Std.string(fallback)));
        return parsed == null ? fallback : parsed;
    }

    private static function decode(value:String):String {
        if (value.indexOf("%") == -1) return value;
        try return StringTools.urlDecode(value) catch (_:Dynamic) return value;
    }
}
