package com.sulake.habbo.communication.messages.parser.habbicons
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;
    import com.sulake.core.communication.messages.IMessageParser;

     class RoomUserHabbiconMessageParser implements IMessageParser
    {
        var _roomIndex:Int = 0;
        var _habbiconId:Int = 0;

        public var roomIndex(get,never):Int;
public function  get_roomIndex():Int
        {
            return this._roomIndex;
        }

        public var habbiconId(get,never):Int;
public function  get_habbiconId():Int
        {
            return this._habbiconId;
        }

        public function flush():Bool
        {
            this._roomIndex = 0;
            this._habbiconId = 0;
            return true;
        }

        public function parse(wrapper:IMessageDataWrapper):Bool
        {
            this._roomIndex = wrapper.readInteger();
            this._habbiconId = wrapper.readInteger();
            return true;
        }

	public function new() {}
    }

