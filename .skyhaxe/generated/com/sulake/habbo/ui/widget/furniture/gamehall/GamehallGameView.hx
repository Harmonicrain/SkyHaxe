package com.sulake.habbo.ui.widget.furniture.gamehall
;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.events.WindowEvent;
    import flash.display.Sprite;

     interface GamehallGameView
    {
        function reset(localSeat:Int, seatCount:Int):Void;
        function applyUpdate(verb:String="", args:Array<ASAny>=null, reason:String=""):Void;
        function render(panel:Sprite, assets:GamehallAssetLibrary):Void;
        function handleWindowEvent(event:WindowEvent, window:IWindow):Void;
        function dispose():Void;
    }

