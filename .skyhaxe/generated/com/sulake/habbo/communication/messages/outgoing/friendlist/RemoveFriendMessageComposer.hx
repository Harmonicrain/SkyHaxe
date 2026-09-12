package com.sulake.habbo.communication.messages.outgoing.friendlist
;
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.runtime.IDisposable;

     class RemoveFriendMessageComposer implements IMessageComposer implements  IDisposable 
    {
        var _removedAvatarIds:Array<ASAny>;

        public function new()
        {
            this._removedAvatarIds = new Array<ASAny>();
        }

        public function getMessageArray():Array<ASAny>
        {
            var k= new Array<ASAny>();
            k.push(this._removedAvatarIds.length);
            var _local_2 = 0;
            while (_local_2 < this._removedAvatarIds.length)
            {
                k.push(this._removedAvatarIds[_local_2]);
                _local_2++;
            }
            return k;
        }

        public function addRemovedFriend(k:Int)
        {
            this._removedAvatarIds.push(k);
        }

        public function dispose()
        {
            this._removedAvatarIds = null;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return false;
        }
    }

