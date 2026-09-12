package com.sulake.habbo.window.widgets
;
    import com.sulake.core.window.IWidget;
    import com.sulake.core.window.utils.IBitmapDataContainer;

     interface IBadgeImageWidget extends IWidget extends  IBitmapDataContainer
    {
                var type(get,set):String;
                var badgeId(get,set):String;
                var groupId(get,set):Int;
    }

