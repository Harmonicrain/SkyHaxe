package com.sulake.habbo.communication.messages.outgoing.users
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class ApproveNameMessageComposer implements IMessageComposer
    {
        var _name:String;
        var _type:Int = 0;

        public function new(k:String, _arg_2:Int)
        {
            this._name = k;
            this._type = _arg_2;
        }

        public function getMessageArray():Array<ASAny>
        {
            return [this._name, this._type];
        }

        public function dispose()
        {
        }
    }

