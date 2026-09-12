package com.sulake.habbo.communication.messages.outgoing.userdefinedroomevents
;
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.runtime.IDisposable;

    /** July request-all-variable-hash message. The wire body is empty. */
     class RequestAllVariablesHashMessageComposer implements IMessageComposer implements  IDisposable
    {
        var _array:Array<ASAny> = [];

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
            return this._array == null;
        }
public function new(){}
    }

