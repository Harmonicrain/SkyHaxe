package com.sulake.habbo.communication.messages.parser.roomsettings
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.roomsettings.FlatControllerData;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class FlatControllersMessageParser implements IMessageParser
    {
        var _roomId:Int = 0;
        var _controllers:Array<ASAny>;


        public function parse(k:IMessageDataWrapper):Bool
        {
            this._roomId = k.readInteger();
            var _local_2= k.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                this._controllers.push(new FlatControllerData(k));
                _local_3++;
            }
            return true;
        }

        public function flush():Bool
        {
            this._controllers = [];
            return true;
        }

        public var roomId(get,never):Int;
public function  get_roomId():Int
        {
            return this._roomId;
        }

        public var controllers(get,never):Array<ASAny>;
public function  get_controllers():Array<ASAny>
        {
            return this._controllers;
        }

	public function new() {}
    }

