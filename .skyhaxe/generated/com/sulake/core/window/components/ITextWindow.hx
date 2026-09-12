package com.sulake.core.window.components
;
    import com.sulake.core.window.IWindow;
    import flash.text.TextFormat;
    import com.sulake.core.window.utils.IMargins;
    import com.sulake.core.window.utils.TextStyle;
    import flash.text.StyleSheet;
    import flash.geom.Rectangle;
    import flash.display.DisplayObject;
    import flash.text.TextLineMetrics;

     interface ITextWindow extends IWindow extends  IScrollableWindow 
    {
                var antiAliasType(get,set):String;
                var autoSize(get,set):String;
                var bold(get,set):Bool;
                var border(get,set):Bool;
                var borderColor(get,set):UInt;
        var bottomScrollV(get,never):Int;
                var defaultTextFormat(get,set):TextFormat;
                var embedFonts(get,set):Bool;
                var fontFace(get,set):String;
                var fontSize(get,set):UInt;
                var gridFitType(get,set):String;
                var htmlText(get,set):String;
                var italic(get,set):Bool;
                var kerning(get,set):Bool;
        var length(get,never):Int;
        var margins(get,never):IMargins;
                var maxChars(get,set):Int;
                var maxLines(get,set):Int;
                var multiline(get,set):Bool;
        var numLines(get,never):Int;
                var overflowReplace(get,set):String;
                var sharpness(get,set):Float;
                var spacing(get,set):Float;
                var text(get,set):String;
                var textColor(get,set):UInt;
                var textBackground(get,set):Bool;
                var textBackgroundColor(get,set):UInt;
        var textHeight(get,never):Float;
        var textWidth(get,never):Float;
                var textStyle(get,set):TextStyle;
                var thickness(get,set):Float;
                var underline(get,set):Bool;
                var wordWrap(get,set):Bool;
                var etchingColor(get,set):UInt;
                var etchingPosition(get,set):String;
        var styleSheet(never,set):StyleSheet;
        function appendText(_arg_1:String):Void;
        function getCharBoundaries(_arg_1:Int):Rectangle;
        function getCharIndexAtPoint(_arg_1:Float, _arg_2:Float):Int;
        function getFirstCharInParagraph(_arg_1:Int):Int;
        function getImageReference(_arg_1:String):DisplayObject;
        function getLineIndexAtPoint(_arg_1:Float, _arg_2:Float):Int;
        function getLineIndexOfChar(_arg_1:Int):Int;
        function getLineLength(_arg_1:Int):Int;
        function getLineMetrics(_arg_1:Int):TextLineMetrics;
        function getLineOffset(_arg_1:Int):Int;
        function getLineText(_arg_1:Int):String;
        function getParagraphLength(_arg_1:Int):Int;
        function getTextFormat(_arg_1:Int=-1, _arg_2:Int=-1):TextFormat;
        function replaceText(_arg_1:Int, _arg_2:Int, _arg_3:String):Void;
        function setTextFormat(_arg_1:TextFormat, _arg_2:Int=-1, _arg_3:Int=-1):Void;
        function resetExplicitStyle():Void;
    }

