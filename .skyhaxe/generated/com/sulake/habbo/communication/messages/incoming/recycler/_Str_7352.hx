package com.sulake.habbo.communication.messages.incoming.recycler
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class _Str_7352 
    {
        var _Str_18365:Int = 1;
        var _productCode:String;
        var _Str_7699:Array<ASAny>;
        var _Str_6780:String;
        var _Str_6222:Int = 0;

        public function new(k:IMessageDataWrapper)
        {
            var _local_2 = 0;
            this._Str_7699 = [];
            this._productCode = k.readString();
            this._Str_18365 = k.readInteger();
            if (!this._Str_19070)
            {
                this._Str_6780 = k.readString();
                this._Str_6222 = k.readInteger();
            }
            else
            {
                while (_local_2 < this._Str_18365)
                {
                    this._Str_7699.push(new _Str_6068(k));
                    _local_2++;
                }
            }
        }

        public var _Str_7585(get,never):String;
public function  get__Str_7585():String
        {
            return this._Str_6780;
        }

        public var _Str_6270(get,never):Int;
public function  get__Str_6270():Int
        {
            return this._Str_6222;
        }

        public var _Str_19070(get,never):Bool;
public function  get__Str_19070():Bool
        {
            return this._Str_18365 > 1;
        }

        public var _Str_9475(get,never):Array<ASAny>;
public function  get__Str_9475():Array<ASAny>
        {
            return this._Str_7699;
        }

        public var productCode(get,never):String;
public function  get_productCode():String
        {
            return this._productCode;
        }
    }

