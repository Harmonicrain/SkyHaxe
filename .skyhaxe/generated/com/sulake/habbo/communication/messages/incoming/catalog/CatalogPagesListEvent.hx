package com.sulake.habbo.communication.messages.incoming.catalog
;
    import com.sulake.core.communication.messages.MessageEvent;
    import com.sulake.core.communication.messages.IMessageEvent;
    import com.sulake.habbo.communication.messages.parser.catalog.CatalogIndexMessageParser;

     class CatalogPagesListEvent extends MessageEvent implements IMessageEvent 
    {
        public function new(k:ASFunction)
        {
            super(k, CatalogIndexMessageParser);
        }

        public function getParser():CatalogIndexMessageParser
        {
            return Std.downcast(this._parser , CatalogIndexMessageParser);
        }

        public var root(get,never):NodeData;
public function  get_root():NodeData
        {
            return this.getParser().root;
        }

        public var _Str_16264(get,never):Bool;
public function  get__Str_16264():Bool
        {
            return this.getParser().newAdditionsAvailable;
        }

        public var catalogType(get,never):String;
public function  get_catalogType():String
        {
            return this.getParser().catalogType;
        }
    }

