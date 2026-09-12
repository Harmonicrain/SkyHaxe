package com.sulake.habbo.communication.messages.outgoing.moderator
;
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.runtime.IDisposable;

     class CloseIssuesMessageComposer implements IMessageComposer implements  IDisposable 
    {
        var _array:Array<ASAny>;

        public function new(k:Array<ASAny>, _arg_2:Int)
        {
            this._array = new Array<ASAny>();
            this._array.push(_arg_2);
            this._array.push(k.length);
            var _local_3 = 0;
            while (_local_3 < k.length)
            {
                this._array.push(k[_local_3]);
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

