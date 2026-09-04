package com.sulake.habbo.communication.messages.parser.catalog
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class CatalogPageExpirationParser implements IMessageParser
    {
        var _pageName:String;
        var _pageId:Int = 0;
        var _Str_5158:Int = 0;
        var _image:String;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._pageId = k.readInteger();
            this._pageName = k.readString();
            this._Str_5158 = k.readInteger();
            this._image = k.readString();
            return true;
        }

        public var pageName(get,never):String;
function  get_pageName():String
        {
            return this._pageName;
        }

        public var pageId(get,never):Int;
function  get_pageId():Int
        {
            return this._pageId;
        }

        public var _Str_17123(get,never):Int;
function  get__Str_17123():Int
        {
            return this._Str_5158;
        }

        public var image(get,never):String;
function  get_image():String
        {
            return this._image;
        }

	public function new() {}
    }

