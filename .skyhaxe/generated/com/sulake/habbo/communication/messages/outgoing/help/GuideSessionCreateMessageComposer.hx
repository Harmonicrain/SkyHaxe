package com.sulake.habbo.communication.messages.outgoing.help
;
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.runtime.IDisposable;

     class GuideSessionCreateMessageComposer implements IMessageComposer implements  IDisposable
    {
        var _array:Array<ASAny>;
        var _disposed:Bool = false;

        public function new(k:Int, _arg_2:String)
        {
            this._array = [];
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
            this._disposed = true;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }
    }

