package com.sulake.habbo.communication.messages.parser.room.engine
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class UserChangeMessageParser implements IMessageParser
    {
        var _id:Int = 0;
        var _figure:String;
        var _sex:String;
        var _customInfo:String;
        var _activityPoints:Int = 0;


        public var id(get,never):Int;
public function  get_id():Int
        {
            return this._id;
        }

        public var figure(get,never):String;
public function  get_figure():String
        {
            return this._figure;
        }

        public var sex(get,never):String;
public function  get_sex():String
        {
            return this._sex;
        }

        public var customInfo(get,never):String;
public function  get_customInfo():String
        {
            return this._customInfo;
        }

        public var activityPoints(get,never):Int;
public function  get_activityPoints():Int
        {
            return this._activityPoints;
        }

        public function flush():Bool
        {
            this._id = 0;
            this._figure = "";
            this._sex = "";
            this._customInfo = "";
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._id = k.readInteger();
            this._figure = k.readString();
            this._sex = k.readString();
            this._customInfo = k.readString();
            this._activityPoints = k.readInteger();
            if (ASCompat.stringAsBool(this._sex))
            {
                this._sex = this._sex.toUpperCase();
            }
            return true;
        }

	public function new() {}
    }

