package com.sulake.habbo.communication.messages.parser.campaign
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class CampaignCalendarDoorOpenedMessageParser implements IMessageParser
    {
        var _Str_17229:Bool = false;
        var _productName:String;
        var _customImage:String;
        var _Str_6002:String;


        public function parse(k:IMessageDataWrapper):Bool
        {
            this._Str_17229 = k.readBoolean();
            this._productName = k.readString();
            this._customImage = k.readString();
            this._Str_6002 = k.readString();
            return true;
        }

        public function flush():Bool
        {
            this._Str_17229 = false;
            this._productName = null;
            this._customImage = null;
            this._Str_6002 = null;
            return true;
        }

        public var _Str_22341(get,never):Bool;
public function  get__Str_22341():Bool
        {
            return this._Str_17229;
        }

        public var productName(get,never):String;
public function  get_productName():String
        {
            return this._productName;
        }

        public var customImage(get,never):String;
public function  get_customImage():String
        {
            return this._customImage;
        }

        public var _Str_8979(get,never):String;
public function  get__Str_8979():String
        {
            return this._Str_6002;
        }

	public function new() {}
    }

