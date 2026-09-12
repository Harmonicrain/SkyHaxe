package com.sulake.habbo.ui.widget.avatarinfo.botskills
;
    import com.sulake.core.runtime.IDisposable;
    import flash.geom.Point;

     interface BotSkillConfigurationView extends IDisposable 
    {
        function open(_arg_1:Int, _arg_2:Point=null):Void;
        function close():Void;
        function parseConfiguration(_arg_1:String):Void;
    }

