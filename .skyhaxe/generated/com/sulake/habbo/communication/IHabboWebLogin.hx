package com.sulake.habbo.communication
;
    import flash.events.IEventDispatcher;

     interface IHabboWebLogin extends IEventDispatcher 
    {
        function requestReAuthenticate():Void;
        function init():Void;
    }

