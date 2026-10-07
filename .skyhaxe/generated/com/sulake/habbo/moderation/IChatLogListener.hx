package com.sulake.habbo.moderation
;

     interface IChatLogListener 
    {
        function onChatlog(_arg_1:String, _arg_2:Int, _arg_3:Int, _arg_4:Array<ASAny>, _arg_5:ASDictionary<ASAny,ASAny>):Void;
    }

