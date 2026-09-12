package com.sulake.habbo.communication.messages.outgoing.notifications
;
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.runtime.IDisposable;

     class ResetUnseenItemIdsComposer implements IMessageComposer implements  IDisposable
    {
        var _array:Array<ASAny>;

        public function new(k:Int)
        {
            this._array = new Array<ASAny>();
            this._array.push(k);
        }

        public function getMessageArray():Array<ASAny>
        {
            return this._array;
        }

        public function dispose()
        {
            this._array = null;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return false;
        }
    }

