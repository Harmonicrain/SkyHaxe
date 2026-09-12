package com.sulake.habbo.communication.messages.parser.notifications
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.utils.Map;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class NotificationDialogMessageParser implements IMessageParser
    {
        var _type:String;
        var _parameters:Map;


        public function flush():Bool
        {
            this._type = null;
            this._parameters = null;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            var _local_4:String = null;
            var _local_5:String = null;
            this._type = k.readString();
            this._parameters = new Map();
            var _local_2= k.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                _local_4 = k.readString();
                _local_5 = k.readString();
                this._parameters.add(_local_4, _local_5);
                _local_3++;
            }
            return true;
        }

        public var type(get,never):String;
public function  get_type():String
        {
            return this._type;
        }

        public var parameters(get,never):Map;
public function  get_parameters():Map
        {
            return this._parameters;
        }

	public function new() {}
    }

