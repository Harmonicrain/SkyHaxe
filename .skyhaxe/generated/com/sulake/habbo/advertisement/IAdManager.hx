package com.sulake.habbo.advertisement
;
    import com.sulake.core.runtime.IUnknown;
    import flash.events.IEventDispatcher;

     interface IAdManager extends IUnknown 
    {
        var events(get,never):IEventDispatcher;
        function showInterstitial():Void;
        function loadRoomAdImage(_arg_1:Int, _arg_2:Int, _arg_3:Int, _arg_4:String, _arg_5:String):Void;
    }

