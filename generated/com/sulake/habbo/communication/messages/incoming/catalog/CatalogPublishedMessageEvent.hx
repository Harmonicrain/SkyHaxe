package com.sulake.habbo.communication.messages.incoming.catalog
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.catalog.CatalogPublishedMessageParser;

     class CatalogPublishedMessageEvent extends MessageEvent implements IMessageEvent
    {
        public function new(k:ASFunction)
        {
            super(k, CatalogPublishedMessageParser);
        }

        public function getParser():CatalogPublishedMessageParser
        {
            return Std.downcast(this._parser , CatalogPublishedMessageParser);
        }

        public var _Str_17070(get,never):Bool;
function  get__Str_17070():Bool
        {
            return this.getParser()._Str_17070;
        }

        public var _Str_12669(get,never):String;
function  get__Str_12669():String
        {
            return this.getParser()._Str_12669;
        }
    }

