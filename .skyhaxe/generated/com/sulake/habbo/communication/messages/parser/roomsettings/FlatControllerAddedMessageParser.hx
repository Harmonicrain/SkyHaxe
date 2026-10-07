package com.sulake.habbo.communication.messages.parser.roomsettings
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.roomsettings.FlatControllerData;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class FlatControllerAddedMessageParser implements IMessageParser
    {
        var _flatId:Int = 0;
        var _data:FlatControllerData;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._flatId = k.readInteger();
            this._data = new FlatControllerData(k);
            return true;
        }

        public var flatId(get,never):Int;
public function  get_flatId():Int
        {
            return this._flatId;
        }

        public var data(get,never):FlatControllerData;
public function  get_data():FlatControllerData
        {
            return this._data;
        }

	public function new() {}
    }

