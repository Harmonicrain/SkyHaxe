package com.sulake.habbo.communication.messages.outgoing.room.session
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class OpenFlatConnectionMessageComposer implements IMessageComposer
    {
        var _message:Array<ASAny>;

        public function new(k:Int, _arg_2:String="", _arg_3:Int=-1)
        {
            this._message = [k, _arg_2, _arg_3];
        }

        public function dispose()
        {
            this._message = null;
        }

        public function getMessageArray():Array<ASAny>
        {
            return this._message;
        }
    }

