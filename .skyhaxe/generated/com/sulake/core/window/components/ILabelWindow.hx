package com.sulake.core.window.components
;
    import com.sulake.core.window.IWindow;
    import flash.text.TextFormat;
    import com.sulake.core.window.utils.IMargins;
    import com.sulake.core.window.utils.TextStyle;

     interface ILabelWindow extends IWindow 
    {
        var antiAliasType(get,never):String;
        var autoSize(get,never):String;
        var bold(get,never):Bool;
        var border(get,never):Bool;
        var borderColor(get,never):UInt;
        var defaultTextFormat(get,never):TextFormat;
        var embedFonts(get,never):Bool;
        var fontFace(get,never):String;
        var fontSize(get,never):UInt;
        var gridFitType(get,never):String;
        var italic(get,never):Bool;
        var kerning(get,never):Bool;
        var length(get,never):Int;
        var margins(get,never):IMargins;
        var maxChars(get,never):Int;
        var sharpness(get,never):Float;
        var spacing(get,never):Float;
                var text(get,set):String;
                var textColor(get,set):UInt;
        var textBackground(get,never):Bool;
        var textBackgroundColor(get,never):UInt;
        var textHeight(get,never):Float;
        var textWidth(get,never):Float;
                var textStyle(get,set):TextStyle;
        var thickness(get,never):Float;
        var underline(get,never):Bool;
                var vertical(get,set):Bool;
    }

