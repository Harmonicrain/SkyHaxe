package com.sulake.habbo.window.utils
;
    import com.sulake.core.runtime.IDisposable;

     interface IAlertDialog extends IDisposable
    {
                var title(get,set):String;
                var summary(get,set):String;
                var callback(get,set):ASFunction;
        function getButtonCaption(_arg_1:Int):ICaption;
        function setButtonCaption(_arg_1:Int, _arg_2:ICaption):Void;
    }

