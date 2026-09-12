package com.sulake.habbo.communication.messages.outgoing.groupforums
;
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.runtime.IDisposable;

     class PostMessageMessageComposer implements IMessageComposer implements  IDisposable 
    {
        var _array:Array<ASAny>;

        public function new(k:Int, _arg_2:Int, _arg_3:String, _arg_4:String)
        {
            this._array = [k, _arg_2, _arg_3, _arg_4];
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

