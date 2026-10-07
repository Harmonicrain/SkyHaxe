package com.sulake.habbo.communication.messages.parser.mysterybox
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class GotMysteryBoxPrizeMessageParser implements IMessageParser 
    {
        var _contentType:String;
        var _classId:Int = 0;


        public function flush():Bool
        {
            this._contentType = null;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._contentType = k.readString();
            this._classId = k.readInteger();
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

	public function new() {}
    }

