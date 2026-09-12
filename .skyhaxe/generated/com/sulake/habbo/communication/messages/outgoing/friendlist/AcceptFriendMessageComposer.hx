package com.sulake.habbo.communication.messages.outgoing.friendlist
;
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.runtime.IDisposable;

     class AcceptFriendMessageComposer implements IMessageComposer implements  IDisposable 
    {
        var _acceptedRequestIds:Array<ASAny>;

        public function new()
        {
            this._acceptedRequestIds = new Array<ASAny>();
        }

        public function getMessageArray():Array<ASAny>
        {
            var k= new Array<ASAny>();
            k.push(this._acceptedRequestIds.length);
            var _local_2 = 0;
            while (_local_2 < this._acceptedRequestIds.length)
            {
                k.push(this._acceptedRequestIds[_local_2]);
                _local_2++;
            }
            return k;
        }

        public function addAcceptedRequest(k:Int)
        {
            this._acceptedRequestIds.push(k);
        }

        public function dispose()
        {
            this._acceptedRequestIds = null;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return false;
        }
    }

