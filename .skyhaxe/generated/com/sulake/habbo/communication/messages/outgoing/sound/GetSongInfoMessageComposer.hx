package com.sulake.habbo.communication.messages.outgoing.sound
;
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.runtime.IDisposable;

     class GetSongInfoMessageComposer implements IMessageComposer implements  IDisposable
    {
        var _array:Array<ASAny>;

        public function new(k:Array<ASAny>)
        {
            var _local_2 = 0;
            this._array = new Array<ASAny>();
            this._array.push(k.length);
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
_local_2  = ASCompat.toInt(_tmp_);
                this._array.push(_local_2);
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

