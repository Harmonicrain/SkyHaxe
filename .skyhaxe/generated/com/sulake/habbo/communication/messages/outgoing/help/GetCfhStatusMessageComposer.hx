package com.sulake.habbo.communication.messages.outgoing.help
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class GetCfhStatusMessageComposer implements IMessageComposer
    {
        var _Str_22113:Bool = false;

        public function new(k:Bool)
        {
            this._Str_22113 = k;
        }

        public function getMessageArray():Array<ASAny>
        {
            return [this._Str_22113];
        }

        public function dispose()
        {
        }
    }

