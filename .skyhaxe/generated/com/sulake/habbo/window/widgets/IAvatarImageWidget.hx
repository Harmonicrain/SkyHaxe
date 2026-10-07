package com.sulake.habbo.window.widgets
;
    import com.sulake.core.window.IWidget;

     interface IAvatarImageWidget extends IWidget
    {
                var figure(get,set):String;
                var scale(get,set):String;
                var onlyHead(get,set):Bool;
                var cropped(get,set):Bool;
                var direction(get,set):Int;
                var userId(get,set):Int;
    }

