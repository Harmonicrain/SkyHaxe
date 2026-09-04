package com.sulake.habbo.communication.messages.parser.handshake
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class UserObjectMessageParser implements IMessageParser
    {
        var _id:Int = 0;
        var _name:String;
        var _figure:String;
        var _sex:String;
        var _customData:String;
        var _realName:String;
        var _directMail:Bool = false;
        var _respectTotal:Int = 0;
        var _respectLeft:Int = 0;
        var _petRespectLeft:Int = 0;
        var _streamPublishingAllowed:Bool = false;
        var _lastAccessDate:String;
        var _nameChangeAllowed:Bool = false;
        var _accountSafetyLocked:Bool = false;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._id = k.readInteger();
            this._name = k.readString();
            this._figure = k.readString();
            this._sex = k.readString();
            this._customData = k.readString();
            this._realName = k.readString();
            this._directMail = k.readBoolean();
            this._respectTotal = k.readInteger();
            this._respectLeft = k.readInteger();
            this._petRespectLeft = k.readInteger();
            this._streamPublishingAllowed = k.readBoolean();
            this._lastAccessDate = k.readString();
            this._nameChangeAllowed = k.readBoolean();
            this._accountSafetyLocked = k.readBoolean();
            return true;
        }

        public var id(get,never):Int;
function  get_id():Int
        {
            return this._id;
        }

        public var name(get,never):String;
function  get_name():String
        {
            return this._name;
        }

        public var figure(get,never):String;
function  get_figure():String
        {
            return this._figure;
        }

        public var sex(get,never):String;
function  get_sex():String
        {
            return this._sex;
        }

        public var _Str_3073(get,never):String;
function  get__Str_3073():String
        {
            return this._customData;
        }

        public var realName(get,never):String;
function  get_realName():String
        {
            return this._realName;
        }

        public var directMail(get,never):Bool;
function  get_directMail():Bool
        {
            return this._directMail;
        }

        public var respectTotal(get,never):Int;
function  get_respectTotal():Int
        {
            return this._respectTotal;
        }

        public var respectLeft(get,never):Int;
function  get_respectLeft():Int
        {
            return this._respectLeft;
        }

        public var petRespectLeft(get,never):Int;
function  get_petRespectLeft():Int
        {
            return this._petRespectLeft;
        }

        public var streamPublishingAllowed(get,never):Bool;
function  get_streamPublishingAllowed():Bool
        {
            return this._streamPublishingAllowed;
        }

        public var lastAccessDate(get,never):String;
function  get_lastAccessDate():String
        {
            return this._lastAccessDate;
        }

        public var nameChangeAllowed(get,never):Bool;
function  get_nameChangeAllowed():Bool
        {
            return this._nameChangeAllowed;
        }

        public var accountSafetyLocked(get,never):Bool;
function  get_accountSafetyLocked():Bool
        {
            return this._accountSafetyLocked;
        }

	public function new() {}
    }

