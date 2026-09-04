package com.sulake.core.runtime.exceptions
;
    import Globals.flash_utils_getQualifiedClassName as getQualifiedClassName;

     class Exception extends ASError 
    {
        var _cause:ASError;

        public function new(message:String, id:Int=0, cause:ASError=null)
        {
            super(message, id);
            this._cause = cause;
        }

        public static function getChainedStackTrace(error:ASError):String
        {
            var stacktrace:String;
            var out:String = null;
            while (error != null)
            {
                stacktrace = error.getStackTrace();
                if (stacktrace != null)
                {
                    if (out == null)
                    {
                        out = stacktrace;
                    }
                    else
                    {
                        out = (out + "\ncaused by ");
                        out = (out + stacktrace);
                    }
                }
                if (Std.is(error , Exception))
                {
                    error = Std.downcast(error , Exception).cause;
                }
                else
                {
                    error = null;
                }
            }
            return out;
        }


        public var cause(get,never):ASError;
function  get_cause():ASError
        {
            return this._cause;
        }

        override public function toString():String
        {
            var message= ((getQualifiedClassName(this) + ": ") + this.message);
            if (this._cause != null)
            {
                message = (message + ", caused by ");
                message = (message + this._cause.toString());
            }
            return message;
        }
    }

