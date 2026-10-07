package com.sulake.habbo.communication.messages.parser.notifications
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class OfferRewardDeliveredMessageParser implements IMessageParser
    {
        var _contentType:String;
        var _classId:Int = 0;
        var _name:String;
        var _description:String;


        public function flush():Bool
        {
            this._contentType = null;
            this._classId = 0;
            this._name = null;
            this._description = null;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._contentType = k.readString();
            this._classId = k.readInteger();
            this._name = k.readString();
            this._description = k.readString();
            return true;
        }

        public var contentType(get,never):String;
public function  get_contentType():String
        {
            return this._contentType;
        }

        public var classId(get,never):Int;
public function  get_classId():Int
        {
            return this._classId;
        }

        public var name(get,never):String;
public function  get_name():String
        {
            return this._name;
        }

        public var description(get,never):String;
public function  get_description():String
        {
            return this._description;
        }

	public function new() {}
    }

