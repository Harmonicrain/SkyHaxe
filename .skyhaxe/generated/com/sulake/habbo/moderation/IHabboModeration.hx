package com.sulake.habbo.moderation
;
    import com.sulake.core.runtime.IUnknown;

     interface IHabboModeration extends IUnknown 
    {
        function userSelected(_arg_1:Int, _arg_2:String, figure:String = null, gender:String = null):Void;
		
		function setVisible(visible:Bool):Void;
    }

