package com.sulake.habbo.communication.messages.parser.catalog
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.catalog.NodeData;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class CatalogIndexMessageParser implements IMessageParser
    {
        var _root:NodeData;
        var _newAdditionsAvailable:Bool = false;
        var _catalogType:String;


        public var root(get,never):NodeData;
public function  get_root():NodeData
        {
            return this._root;
        }

        public var newAdditionsAvailable(get,never):Bool;
public function  get_newAdditionsAvailable():Bool
        {
            return this._newAdditionsAvailable;
        }

        public var catalogType(get,never):String;
public function  get_catalogType():String
        {
            return this._catalogType;
        }

        public function flush():Bool
        {
            this._root = null;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._root = new NodeData(k);
            this._newAdditionsAvailable = k.readBoolean();
            this._catalogType = k.readString();
            return true;
        }

	public function new() {}
    }

