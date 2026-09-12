package com.sulake.habbo.communication.messages.outgoing.moderator
;
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.runtime.IDisposable;

     class CloseIssueDefaultActionMessageComposer implements IMessageComposer implements  IDisposable 
    {
        var _array:Array<ASAny>;

        public function new(k:Int, _arg_2:Array<ASAny>, _arg_3:Int)
        {
            this._array = new Array<ASAny>();
            this._array.push(k);
            this._array.push(_arg_2.length);
            var _local_4 = 0;
            while (_local_4 < _arg_2.length)
            {
                this._array.push(_arg_2[_local_4]);
                _local_4++;
            }
            this._array.push(_arg_3);
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

