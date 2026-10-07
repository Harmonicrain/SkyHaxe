package com.sulake.core.runtime
;
    import flash.events.IEventDispatcher;

     interface ICore extends IContext extends  IHabboConfigurationManager 
    {
        function initialize():Void;
        function purge():Void;
        function hibernate(_arg_1:Int, _arg_2:Int=1):Void;
        function resume():Void;
        function readConfigDocument(_arg_1:com.sulake.core.utils.xml.XML, _arg_2:IEventDispatcher=null):Void;
        function getNumberOfFilesPending():UInt;
        function getNumberOfFilesLoaded():UInt;
        function setProfilerMode(_arg_1:Bool):Void;
    }

