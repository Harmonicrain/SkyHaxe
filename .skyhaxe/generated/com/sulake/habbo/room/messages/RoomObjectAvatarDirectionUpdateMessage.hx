package com.sulake.habbo.room.messages
;
    import com.sulake.room.messages.RoomObjectUpdateMessage;
    import com.sulake.room.utils.IVector3d;

     class RoomObjectAvatarDirectionUpdateMessage extends RoomObjectUpdateMessage
    {
        var _dirHead:Int = 0;

        public function new(k:IVector3d, _arg_2:IVector3d, _arg_3:Int)
        {
            super(k, _arg_2);
            this._dirHead = _arg_3;
        }

        public var dirHead(get,never):Int;
public function  get_dirHead():Int
        {
            return this._dirHead;
        }
    }

