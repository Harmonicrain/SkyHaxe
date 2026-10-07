package com.sulake.habbo.avatar
;
    import com.sulake.core.runtime.IUnknown;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.core.window.IWindowContainer;
    import flash.events.IEventDispatcher;

     interface IHabboAvatarEditor extends IUnknown 
    {
        function openEditor(_arg_1:UInt, _arg_2:_Str_5523, _arg_3:Array<ASAny>=null, _arg_4:Bool=false, _arg_5:String=null, _arg_6:String="generic"):IFrameWindow;
        function embedEditorToContext(_arg_1:UInt, _arg_2:IWindowContainer, _arg_3:_Str_5523=null, _arg_4:Array<ASAny>=null, _arg_5:Bool=false, _arg_6:Bool=false):Bool;
        function loadAvatarInEditor(_arg_1:UInt, _arg_2:String, _arg_3:String, _arg_4:Int=0):Void;
        function loadOwnAvatarInEditor(_arg_1:UInt):Void;
        var events(get,never):IEventDispatcher;
        function close(_arg_1:UInt):Void;
    }

