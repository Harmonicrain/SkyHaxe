package com.sulake.habbo.communication.messages.outgoing.notifications
;
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.runtime.IDisposable;

     class ResetUnseenItemsComposer implements IMessageComposer implements  IDisposable
    {
        var _array:Array<ASAny>;

        public function new(k:Int, _arg_2:Array<ASAny>)
        {
            this._array = new Array<ASAny>();
            this._array.push(k);
            this._array.push(_arg_2.length);
            this._array = this._array.concat(_arg_2);
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

