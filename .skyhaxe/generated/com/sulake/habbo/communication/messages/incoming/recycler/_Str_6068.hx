package com.sulake.habbo.communication.messages.incoming.recycler
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class _Str_6068 
    {
        var _Str_6780:String;
        var _Str_6222:Int = 0;

        public function new(k:IMessageDataWrapper)
        {
            this._Str_6780 = k.readString();
            this._Str_6222 = k.readInteger();
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
    }

