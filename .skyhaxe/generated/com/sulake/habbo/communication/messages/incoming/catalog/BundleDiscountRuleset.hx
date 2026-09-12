package com.sulake.habbo.communication.messages.incoming.catalog
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class BundleDiscountRuleset
    {
        var _Str_20535:Int = 0;
        var _Str_19937:Int = 0;
        var _Str_20951:Int = 0;
        var _Str_20460:Int = 0;
        var _Str_16144:Array<ASAny>;

        public function new(k:IMessageDataWrapper)
        {
            var _local_3 = 0;
            this._Str_20535 = k.readInteger();
            this._Str_19937 = k.readInteger();
            this._Str_20951 = k.readInteger();
            this._Str_20460 = k.readInteger();
            this._Str_16144 = new Array<ASAny>();
            var _local_2= k.readInteger();
            while (_local_3 < _local_2)
            {
                this._Str_16144.push(k.readInteger());
                _local_3++;
            }
        }

        public var _Str_22802(get,never):Int;
public function  get__Str_22802():Int
        {
            return this._Str_20535;
        }

        public var _Str_9227(get,never):Int;
public function  get__Str_9227():Int
        {
            return this._Str_19937;
        }

        public var _Str_23802(get,never):Int;
public function  get__Str_23802():Int
        {
            return this._Str_20951;
        }

        public var _Str_21500(get,never):Int;
public function  get__Str_21500():Int
        {
            return this._Str_20460;
        }

        public var _Str_25155(get,never):Array<ASAny>;
public function  get__Str_25155():Array<ASAny>
        {
            return this._Str_16144;
        }
    }

