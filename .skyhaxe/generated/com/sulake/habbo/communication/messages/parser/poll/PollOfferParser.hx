package com.sulake.habbo.communication.messages.parser.poll
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class PollOfferParser implements IMessageParser 
    {
        var _id:Int = -1;
        var _type:String = "";
        var _headline:String = "";
        var _summary:String = "";


        public var id(get,never):Int;
public function  get_id():Int
        {
            return this._id;
        }

        public var type(get,never):String;
public function  get_type():String
        {
            return this._type;
        }

        public var headline(get,never):String;
public function  get_headline():String
        {
            return this._headline;
        }

        public var summary(get,never):String;
public function  get_summary():String
        {
            return this._summary;
        }

        public function flush():Bool
        {
            this._id = -1;
            this._type = "";
            this._summary = "";
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._id = k.readInteger();
            this._type = k.readString();
            this._headline = k.readString();
            this._summary = k.readString();
            return true;
        }

	public function new() {}
    }

