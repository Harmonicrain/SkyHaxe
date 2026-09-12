package com.sulake.habbo.roomevents.wired_trading.contracts.subcontrollers
;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.communication.messages.parser.userdefinedroomevents.wiredtrading.contracts.ChestContractContentsMessageParser;

     interface IContractView
    {
        function show(contents:ChestContractContentsMessageParser):Void;
        function hide():Void;
        function addContentsToComposer(data:Array<ASAny>):Void;
        function contractType():Int;
        function validate():String;
        var window(get,never):IWindow;
    }

