package com.sulake.habbo.communication.messages.outgoing.friendlist
;
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.runtime.IDisposable;

     class DeclineFriendMessageComposer implements IMessageComposer implements  IDisposable 
    {
        var _declinedRequestIds:Array<ASAny>;

        public function new()
        {
            this._declinedRequestIds = new Array<ASAny>();
        }

        public function getMessageArray():Array<ASAny>
        {
            var _local_2 = 0;
            var k= new Array<ASAny>();
            if (this._declinedRequestIds.length == 0)
            {
                k.push(true);
                k.push(0);
            }
            else
            {
                k.push(false);
                k.push(this._declinedRequestIds.length);
                _local_2 = 0;
                while (_local_2 < this._declinedRequestIds.length)
                {
                    k.push(this._declinedRequestIds[_local_2]);
                    _local_2++;
                }
            }
            return k;
        }

        public function addDeclinedRequest(k:Int)
        {
            this._declinedRequestIds.push(k);
        }

        public function dispose()
        {
            this._declinedRequestIds = null;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return false;
        }
    }

