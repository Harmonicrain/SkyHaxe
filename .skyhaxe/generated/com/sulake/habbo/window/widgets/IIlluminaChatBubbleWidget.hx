package com.sulake.habbo.window.widgets
;
    import com.sulake.core.window.IWidget;

     interface IIlluminaChatBubbleWidget extends IWidget
    {
                var flipped(get,set):Bool;
                var userName(get,set):String;
                var userId(get,set):Int;
                var figure(get,set):String;
                var message(get,set):String;
                var habbiconId(get,set):Int;
        var numMessages(get,never):Int;
        function getMessage(_arg_1:Int):ChatBubbleMessage;
        function setMessage(_arg_1:Int, _arg_2:ChatBubbleMessage):Void;
        function appendMessage(_arg_1:ChatBubbleMessage, _arg_2:Bool=false, _arg_3:Int=0):Void;
        function appendTextMessage(_arg_1:String, _arg_2:Bool=false, _arg_3:Int=0):Void;
        function appendHabbiconMessage(_arg_1:Int, _arg_2:Bool=false, _arg_3:Int=0):Void;
        function setAwaitingConfirmationId(_arg_1:Int, _arg_2:Int):Void;
        function clearAwaitingConfirmationId(_arg_1:Int):Void;
        function getAwaitingConfirmationId(_arg_1:Int):Int;
        var underline(never,set):Bool;
                var timeStamp(get,set):Float;
        var friendOnlineStatus(never,set):Bool;
    }

