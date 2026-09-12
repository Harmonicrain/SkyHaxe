package com.sulake.habbo.communication.messages.parser.handshake
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class UniqueMachineIDParser implements IMessageParser 
    {
        var _Str_8149:String;

        public function new()
        {
            this._Str_8149 = "";
        }

        public function flush():Bool
        {
            this._Str_8149 = "";
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._Str_8149 = k.readString();
            return true;
        }

        public var machineID(get,never):String;
public function  get_machineID():String
        {
            return this._Str_8149;
        }
    }

