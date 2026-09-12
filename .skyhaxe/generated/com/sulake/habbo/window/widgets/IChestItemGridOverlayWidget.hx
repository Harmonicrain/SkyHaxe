package com.sulake.habbo.window.widgets
;
    import com.sulake.core.window.IWidget;

    /** July inventory-grid overlay shown for chest categories 24 and 25. */
     interface IChestItemGridOverlayWidget extends IWidget
    {
                var contentsCount(get,set):Int;
                var color(get,set):String;
    }

