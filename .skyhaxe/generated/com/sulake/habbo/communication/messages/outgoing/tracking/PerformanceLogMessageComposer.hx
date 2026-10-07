package com.sulake.habbo.communication.messages.outgoing.tracking
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class PerformanceLogMessageComposer implements IMessageComposer 
    {
        var _array:Array<ASAny>;

        public function new(k:Int, _arg_2:String, _arg_3:String, _arg_4:String, _arg_5:String, _arg_6:Bool, _arg_7:Int, _arg_8:Int, _arg_9:Int, _arg_10:Int, _arg_11:Int)
        {
            this._array = [k, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_9, _arg_10, _arg_11];
        }

        public function dispose()
        {
            this._array = null;
        }

        public function getMessageArray():Array<ASAny>
        {
            return this._array;
        }
    }

