package com.sulake.habbo.communication.messages.parser.users
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class UserNameChangedMessageParser implements IMessageParser 
    {
        var _webId:Int = 0;
        var _id:Int = 0;
        var _newName:String;


        public var webId(get,never):Int;
public function  get_webId():Int
        {
            return this._webId;
        }

        public var id(get,never):Int;
public function  get_id():Int
        {
            return this._id;
        }

        public var newName(get,never):String;
public function  get_newName():String
        {
            return this._newName;
        }

        public function flush():Bool
        {
            this._webId = -1;
            this._id = -1;
            this._newName = "";
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._webId = k.readInteger();
            this._id = k.readInteger();
            this._newName = k.readString();
            return true;
        }

	public function new() {}
    }

