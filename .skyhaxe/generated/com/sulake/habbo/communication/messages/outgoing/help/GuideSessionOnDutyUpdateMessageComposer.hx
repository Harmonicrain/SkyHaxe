package com.sulake.habbo.communication.messages.outgoing.help
;
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.runtime.IDisposable;

     class GuideSessionOnDutyUpdateMessageComposer implements IMessageComposer implements  IDisposable
    {
        var _array:Array<ASAny>;
        var _disposed:Bool = false;

        public function new(k:Bool, _arg_2:Bool, _arg_3:Bool, _arg_4:Bool)
        {
            this._array = [];
            this._array = [k, _arg_2, _arg_3, _arg_4];
        }

        public function getMessageArray():Array<ASAny>
        {
            return this._array;
        }

        public function dispose()
        {
            this._array = null;
            this._disposed = true;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }
    }

