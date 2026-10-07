package com.sulake.habbo.communication.messages.outgoing.room.furniture
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class SetMannequinNameComposer implements IMessageComposer
    {
        var _furniId:Int = 0;
        var _name:String;

        public function new(k:Int, _arg_2:String)
        {
            this._furniId = k;
            this._name = _arg_2;
        }

        public function getMessageArray():Array<ASAny>
        {
            return [this._furniId, this._name];
        }

        public function dispose()
        {
        }
    }

