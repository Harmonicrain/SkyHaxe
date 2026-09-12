package com.sulake.habbo.window.widgets
;
    import com.sulake.core.window.IWidget;

     interface IIlluminaInputWidget extends IWidget
    {
                var message(get,set):String;
                var submitHandler(get,set):IIlluminaInputHandler;
                var buttonCaption(get,set):String;
                var emptyMessage(get,set):String;
                var multiline(get,set):Bool;
                var maxChars(get,set):Int;
    }

