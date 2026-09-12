package com.sulake.habbo.window.widgets
;
    import com.sulake.core.window.IWidget;
    import com.sulake.habbo.room.preview.RoomPreviewer;
    import flash.display.BitmapData;

     interface IRoomPreviewerWidget extends IWidget
    {
                var scale(get,set):Int;
        var roomPreviewer(get,never):RoomPreviewer;
        function showPreview(_arg_1:BitmapData):Void;
                var offsetX(get,set):Int;
                var offsetY(get,set):Int;
                var zoom(get,set):Int;
    }

