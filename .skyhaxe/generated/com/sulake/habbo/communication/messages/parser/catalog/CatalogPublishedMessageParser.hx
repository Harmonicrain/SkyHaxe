package com.sulake.habbo.communication.messages.parser.catalog
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class CatalogPublishedMessageParser implements IMessageParser
    {
        var _Str_21494:Bool = false;
        var _Str_8546:String;


        public function flush():Bool
        {
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._Str_21494 = k.readBoolean();
            if (k.bytesAvailable != 0)
            {
                this._Str_8546 = k.readString();
            }
            return true;
        }

        public var _Str_17070(get,never):Bool;
public function  get__Str_17070():Bool
        {
            return this._Str_21494;
        }

        public var _Str_12669(get,never):String;
public function  get__Str_12669():String
        {
            return this._Str_8546;
        }

	public function new() {}
    }

