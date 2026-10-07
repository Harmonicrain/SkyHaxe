package com.sulake.habbo.communication.messages.outgoing.friendlist
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class SetRelationshipStatusMessageComposer implements IMessageComposer
    {
        var _Str_5045:Int = 0;
        var _Str_19532:Int = 0;

        public function new(k:Int, _arg_2:Int)
        {
            this._Str_5045 = k;
            this._Str_19532 = _arg_2;
        }

        public function getMessageArray():Array<ASAny>
        {
            return [this._Str_5045, this._Str_19532];
        }

        public function dispose()
        {
        }
    }

