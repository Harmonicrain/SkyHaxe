package com.sulake.habbo.catalog.targetedoffers.data
;
     class HabboMallOffer 
    {
        var _targetedOfferId:Int = 0;
        var _identifier:String;
        var _title:String;
        var _highlight:String;
        var _description:String;
        var _imageUrl:String;
        var _smallImageUrl:String;
        var _trackingState:Int = 0;

        public function new(k:ASObject)
        {
            this._targetedOfferId = ASCompat.parseInt(k.targetedOfferId);
            this._identifier = k.identifier;
            this._title = k.header;
            this._highlight = k.highlight;
            this._description = k.description;
            this._imageUrl = k.imageUrl;
            this._smallImageUrl = k.smallImageUrl;
            this._trackingState = ASCompat.parseInt(k.trackingStateCode);
        }

        public var targetedOfferId(get,never):Int;
public function  get_targetedOfferId():Int
        {
            return this._targetedOfferId;
        }

        public var identifier(get,never):String;
public function  get_identifier():String
        {
            return this._identifier;
        }

        public var title(get,never):String;
public function  get_title():String
        {
            return this._title;
        }

        public var highlight(get,never):String;
public function  get_highlight():String
        {
            return this._highlight;
        }

        public var description(get,never):String;
public function  get_description():String
        {
            return this._description;
        }

        public var imageUrl(get,never):String;
public function  get_imageUrl():String
        {
            return this._imageUrl;
        }

        public var smallImageUrl(get,never):String;
public function  get_smallImageUrl():String
        {
            return this._smallImageUrl;
        }

        public var _Str_11180(get,never):Int;
public function  get__Str_11180():Int
        {
            return this._trackingState;
        }
    }

