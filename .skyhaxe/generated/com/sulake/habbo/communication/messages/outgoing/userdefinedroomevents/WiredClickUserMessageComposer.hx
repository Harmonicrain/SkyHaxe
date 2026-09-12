package com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents
;
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.runtime.IDisposable;

     class WiredClickUserMessageComposer implements IMessageComposer implements  IDisposable
    {
        var _array:Array<ASAny>;

        public function new(k:Int, heldTicks:Int=0)
        {
            this._array = new Array<ASAny>();
            this._array.push(k);
            this._array.push(Math.max(0, Math.min(1728000, heldTicks)));
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

