package com.sulake.habbo.communication.messages.incoming.moderation
;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class RoomModerationData implements IDisposable
    {
        var _flatId:Int = 0;
        var _userCount:Int = 0;
        var _ownerInRoom:Bool = false;
        var _ownerId:Int = 0;
        var _ownerName:String;
        var _room:RoomData;
        var _disposed:Bool = false;

        public function new(k:IMessageDataWrapper)
        {
            this._flatId = k.readInteger();
            this._userCount = k.readInteger();
            this._ownerInRoom = k.readBoolean();
            this._ownerId = k.readInteger();
            this._ownerName = k.readString();
            this._room = new RoomData(k);
        }

        public var disposed(get,never):Bool;
function  get_disposed():Bool
        {
            return this._disposed;
        }

        public function dispose()
        {
            if (this._disposed)
            {
                return;
            }
            this._disposed = true;
            if (this._room != null)
            {
                this._room.dispose();
                this._room = null;
            }
        }

        public var flatId(get,never):Int;
function  get_flatId():Int
        {
            return this._flatId;
        }

        public var userCount(get,never):Int;
function  get_userCount():Int
        {
            return this._userCount;
        }

        public var ownerInRoom(get,never):Bool;
function  get_ownerInRoom():Bool
        {
            return this._ownerInRoom;
        }

        public var ownerId(get,never):Int;
function  get_ownerId():Int
        {
            return this._ownerId;
        }

        public var ownerName(get,never):String;
function  get_ownerName():String
        {
            return this._ownerName;
        }

        public var room(get,never):RoomData;
function  get_room():RoomData
        {
            return this._room;
        }
    }

