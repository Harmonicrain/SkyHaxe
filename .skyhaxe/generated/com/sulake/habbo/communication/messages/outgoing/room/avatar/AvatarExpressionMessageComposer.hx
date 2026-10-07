package com.sulake.habbo.communication.messages.outgoing.room.avatar
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class AvatarExpressionMessageComposer implements IMessageComposer
    {
        var _typeCode:Int = 0;

        public function new(k:Int)
        {
            this._typeCode = k;
        }

        public function dispose()
        {
            this._typeCode = 0;
        }

        public function getMessageArray():Array<ASAny>
        {
            return [this._typeCode];
        }
    }

