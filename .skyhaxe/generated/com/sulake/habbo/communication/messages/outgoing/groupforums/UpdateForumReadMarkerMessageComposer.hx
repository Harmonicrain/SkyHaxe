package com.sulake.habbo.communication.messages.outgoing.groupforums
;
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.runtime.IDisposable;

     class UpdateForumReadMarkerMessageComposer implements IMessageComposer implements  IDisposable 
    {
        var _array:Array<ASAny>;

        public function new()
        {
            this._array = [0];
        }

        public function add(k:Int, _arg_2:Int, _arg_3:Bool)
        {
            ASCompat.ASArray.pushMultiple(this._array, k, _arg_2, _arg_3);
            this._array[0]= ASCompat.toNumber(this._array[0])+1;
        }

        public function getMessageArray():Array<ASAny>
        {
            return this._array;
        }

        public var size(get,never):Int;
public function  get_size():Int
        {
            return ASCompat.toInt(this._array[0]);
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

