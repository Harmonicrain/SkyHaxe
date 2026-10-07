package com.sulake.habbo.communication.messages.outgoing.room.session
;
    import com.sulake.core.communication.messages.IMessageComposer;

     class ChangeQueueMessageComposer implements IMessageComposer
    {
        var _targetQueue:Int = 0;

        public function new(k:Int)
        {
            this._targetQueue = k;
        }

        public function getMessageArray():Array<ASAny>
        {
            return [this._targetQueue];
        }

        public function dispose()
        {
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return true;
        }
    }

