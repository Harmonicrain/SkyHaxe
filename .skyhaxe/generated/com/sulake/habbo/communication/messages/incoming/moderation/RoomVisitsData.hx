package com.sulake.habbo.communication.messages.incoming.moderation
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class RoomVisitsData
    {
        var _userId:Int = 0;
        var _userName:String;
        var _rooms:Array<ASAny>;

        public function new(k:IMessageDataWrapper)
        {
            this._rooms = new Array<ASAny>();
            this._userId = k.readInteger();
            this._userName = k.readString();
            var _local_2= k.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                this._rooms.push(new RoomVisitData(k));
                _local_3++;
            }
        }

        public var userId(get,never):Int;
public function  get_userId():Int
        {
            return this._userId;
        }

        public var userName(get,never):String;
public function  get_userName():String
        {
            return this._userName;
        }

        public var rooms(get,never):Array<ASAny>;
public function  get_rooms():Array<ASAny>
        {
            return this._rooms;
        }
    }

