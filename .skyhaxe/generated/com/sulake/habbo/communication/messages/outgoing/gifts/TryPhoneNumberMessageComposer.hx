package com.sulake.habbo.communication.messages.outgoing.gifts
;
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.runtime.IDisposable;

     class TryPhoneNumberMessageComposer implements IMessageComposer implements  IDisposable
    {
        public static inline final NO_ISSUE_ID= -1;

        var _array:Array<ASAny>;

        public function new(k:String, _arg_2:String)
        {
            this._array = new Array<ASAny>();
            this._array.push(k);
            this._array.push(_arg_2);
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

