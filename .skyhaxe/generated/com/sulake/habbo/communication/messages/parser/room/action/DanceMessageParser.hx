package com.sulake.habbo.communication.messages.parser.room.action
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class DanceMessageParser implements IMessageParser 
    {
        var _userId:Int = 0;
        var _danceStyle:Int = 0;


        public var userId(get,never):Int;
public function  get_userId():Int
        {
            return this._userId;
        }

        public var _Str_8263(get,never):Int;
public function  get__Str_8263():Int
        {
            return this._danceStyle;
        }

        public function flush():Bool
        {
            this._userId = 0;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            if (k == null)
            {
                return false;
            }
            this._userId = k.readInteger();
            this._danceStyle = k.readInteger();
            return true;
        }

	public function new() {}
    }

