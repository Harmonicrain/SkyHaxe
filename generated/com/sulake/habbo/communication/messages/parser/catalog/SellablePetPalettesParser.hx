package com.sulake.habbo.communication.messages.parser.catalog
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class SellablePetPalettesParser implements IMessageParser
    {
        var _productCode:String = "";
        var _Str_6479:Array<ASAny>;

        public function new()
        {
            this._Str_6479 = [];
        }

        public var productCode(get,never):String;
function  get_productCode():String
        {
            return this._productCode;
        }

        public var _Str_13588(get,never):Array<ASAny>;
function  get__Str_13588():Array<ASAny>
        {
            return this._Str_6479.slice();
        }

        public function flush():Bool
        {
            this._productCode = "";
            this._Str_6479 = [];
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._productCode = k.readString();
            var _local_2= k.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                this._Str_6479.push(new SellablePetPaletteData(k));
                _local_3++;
            }
            return true;
        }
    }

