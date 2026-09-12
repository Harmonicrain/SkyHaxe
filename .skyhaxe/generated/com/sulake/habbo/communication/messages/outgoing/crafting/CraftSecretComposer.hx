package com.sulake.habbo.communication.messages.outgoing.crafting
;
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.runtime.IDisposable;

     class CraftSecretComposer implements IMessageComposer implements  IDisposable 
    {
        var _array:Array<ASAny>;

        public function new(k:Int, _arg_2:Vector<Int>)
        {
            this._array = new Array<ASAny>();
            this._array.push(k);
            this._array.push(_arg_2.length);
            var _local_3 = 0;
            while (_local_3 < _arg_2.length)
            {
                this._array.push(_arg_2[_local_3]);
                _local_3++;
            }
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

