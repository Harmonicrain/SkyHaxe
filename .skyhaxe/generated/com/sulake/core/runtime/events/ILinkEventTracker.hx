package com.sulake.core.runtime.events
;
     interface ILinkEventTracker 
    {
        var linkPattern(get,never):String;
        function linkReceived(link:String):Void;
    }

