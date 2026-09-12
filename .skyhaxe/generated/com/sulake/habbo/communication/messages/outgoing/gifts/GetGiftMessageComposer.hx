package com.sulake.habbo.communication.messages.outgoing.gifts
;
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.runtime.IDisposable;

     class GetGiftMessageComposer implements IMessageComposer implements  IDisposable
    {
        public static inline final NO_ISSUE_ID= -1;

        var _array:Array<ASAny>;

        public function new()
        {
            this._array = new Array<ASAny>();
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

