package com.sulake.habbo.communication.messages.outgoing.friendlist
;
    import com.sulake.core.communication.messages.IMessageComposer;
    import com.sulake.core.runtime.IDisposable;

     class SendRoomInviteMessageComposer implements IMessageComposer implements  IDisposable 
    {
        var _invitedAvatarIds:Array<ASAny>;
        var _msg:String;

        public function new(k:String)
        {
            this._invitedAvatarIds = new Array<ASAny>();
            this._msg = k;
        }

        public function getMessageArray():Array<ASAny>
        {
            var k= new Array<ASAny>();
            k.push(this._invitedAvatarIds.length);
            var _local_2 = 0;
            while (_local_2 < this._invitedAvatarIds.length)
            {
                k.push(this._invitedAvatarIds[_local_2]);
                _local_2++;
            }
            k.push(this._msg);
            return k;
        }

        public function addInvitedFriend(k:Int)
        {
            this._invitedAvatarIds.push(k);
        }

        public function dispose()
        {
            this._invitedAvatarIds = null;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return false;
        }
    }

