package com.sulake.habbo.communication.messages.parser.avatar
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class CheckUserNameResultMessageParser implements IMessageParser
    {
        var _resultCode:Int = -1;
        var _name:String;
        var _nameSuggestions:Array<ASAny>;


        public var resultCode(get,never):Int;
public function  get_resultCode():Int
        {
            return this._resultCode;
        }

        public var name(get,never):String;
public function  get_name():String
        {
            return this._name;
        }

        public var nameSuggestions(get,never):Array<ASAny>;
public function  get_nameSuggestions():Array<ASAny>
        {
            return this._nameSuggestions;
        }

        public function flush():Bool
        {
            this._resultCode = -1;
            this._name = "";
            this._nameSuggestions = null;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._resultCode = k.readInteger();
            this._name = k.readString();
            var _local_2= k.readInteger();
            this._nameSuggestions = new Array<ASAny>();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                this._nameSuggestions.push(k.readString());
                _local_3++;
            }
            return true;
        }

	public function new() {}
    }

