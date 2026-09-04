package com.sulake.core.runtime
;
     class ConsoleCoreErrorReporter implements ICoreErrorLogger 
    {
        public function logError(k:String, _arg_2:Bool, _arg_3:Int=-1, _arg_4:ASError=null)
        {
            Logger.log(k, ((_arg_4 != null) ? _arg_4.getStackTrace() : ""));
        }
public function new(){}
    }

