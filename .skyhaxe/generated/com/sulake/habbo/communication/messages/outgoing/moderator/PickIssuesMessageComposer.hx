package com.sulake.habbo.communication.messages.outgoing.moderator
;
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.runtime.IDisposable;

     class PickIssuesMessageComposer implements IMessageComposer implements  IDisposable 
    {
        var _array:Array<ASAny>;

        public function new(k:Array<ASAny>, _arg_2:Bool, _arg_3:Int, _arg_4:String)
        {
            this._array = new Array<ASAny>();
            this._array.push(k.length);
            var _local_5 = 0;
            while (_local_5 < k.length)
            {
                this._array.push(k[_local_5]);
                _local_5++;
            }
            this._array.push(_arg_2);
            this._array.push(_arg_3);
            this._array.push(_arg_4);
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

