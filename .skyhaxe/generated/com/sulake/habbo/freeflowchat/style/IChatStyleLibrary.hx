package com.sulake.habbo.freeflowchat.style
;
	import com.sulake.habbo.freeflowchat.style.IChatStyle;
     interface IChatStyleLibrary 
    {
        function getStyleIds():Array<ASAny>;
        function getStyle(_arg_1:Int):IChatStyle;
    }

