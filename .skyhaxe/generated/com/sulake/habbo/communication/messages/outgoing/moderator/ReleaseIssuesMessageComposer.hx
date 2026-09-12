package com.sulake.habbo.communication.messages.outgoing.moderator
;
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.runtime.IDisposable;

     class ReleaseIssuesMessageComposer implements IMessageComposer implements  IDisposable 
    {
        var _array:Array<ASAny>;

        public function new(k:Array<ASAny>)
        {
            this._array = new Array<ASAny>();
            this._array.push(k.length);
            var _local_2 = 0;
            while (_local_2 < k.length)
            {
                this._array.push(k[_local_2]);
                _local_2++;
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

