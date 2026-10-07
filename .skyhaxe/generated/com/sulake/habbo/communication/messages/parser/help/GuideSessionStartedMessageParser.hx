package com.sulake.habbo.communication.messages.parser.help
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class GuideSessionStartedMessageParser implements IMessageParser 
    {
        var _requesterUserId:Int = 0;
        var _requesterName:String;
        var _requesterFigure:String;
        var _guideUserId:Int = 0;
        var _guideName:String;
        var _guideFigure:String;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._requesterUserId = k.readInteger();
            this._requesterName = k.readString();
            this._requesterFigure = k.readString();
            this._guideUserId = k.readInteger();
            this._guideName = k.readString();
            this._guideFigure = k.readString();
            return true;
        }

        public var requesterUserId(get,never):Int;
public function  get_requesterUserId():Int
        {
            return this._requesterUserId;
        }

        public var requesterName(get,never):String;
public function  get_requesterName():String
        {
            return this._requesterName;
        }

        public var requesterFigure(get,never):String;
public function  get_requesterFigure():String
        {
            return this._requesterFigure;
        }

        public var guideUserId(get,never):Int;
public function  get_guideUserId():Int
        {
            return this._guideUserId;
        }

        public var guideName(get,never):String;
public function  get_guideName():String
        {
            return this._guideName;
        }

        public var guideFigure(get,never):String;
public function  get_guideFigure():String
        {
            return this._guideFigure;
        }

	public function new() {}
    }

