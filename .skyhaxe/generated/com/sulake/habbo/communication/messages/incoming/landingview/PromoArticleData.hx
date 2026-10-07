package com.sulake.habbo.communication.messages.incoming.landingview
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class PromoArticleData
    {
        public static inline final LINK_TYPE_URL= 0;
        public static inline final LINK_TYPE_INTERNAL= 1;
        public static inline final LINK_TYPE_NO_LINK= 2;

        var _id:Int = 0;
        var _title:String;
        var _bodyText:String;
        var _buttonText:String;
        var _linkType:Int = 0;
        var _linkContent:String;
        var _imageUrl:String;

        public function new(k:IMessageDataWrapper)
        {
            this._id = k.readInteger();
            this._title = k.readString();
            this._bodyText = k.readString();
            this._buttonText = k.readString();
            this._linkType = k.readInteger();
            this._linkContent = k.readString();
            this._imageUrl = k.readString();
        }

        public var id(get,never):Int;
public function  get_id():Int
        {
            return this._id;
        }

        public var title(get,never):String;
public function  get_title():String
        {
            return this._title;
        }

        public var bodyText(get,never):String;
public function  get_bodyText():String
        {
            return this._bodyText;
        }

        public var buttonText(get,never):String;
public function  get_buttonText():String
        {
            return this._buttonText;
        }

        public var linkType(get,never):Int;
public function  get_linkType():Int
        {
            return this._linkType;
        }

        public var linkContent(get,never):String;
public function  get_linkContent():String
        {
            return this._linkContent;
        }

        public var imageUrl(get,never):String;
public function  get_imageUrl():String
        {
            return this._imageUrl;
        }
    }

