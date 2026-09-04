package com.sulake.habbo.communication.messages.incoming.nux
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class NewUserExperienceGiftProduct
    {
        var _Str_2570:String;
        var _Str_3286:String;

        public function new(k:IMessageDataWrapper)
        {
            this._Str_2570 = k.readString();
            this._Str_3286 = k.readString();
            if (this._Str_3286 == "")
            {
                this._Str_3286 = null;
            }
        }

        public var productCode(get,never):String;
function  get_productCode():String
        {
            return this._Str_2570;
        }

        public var _Str_14499(get,never):String;
function  get__Str_14499():String
        {
            return this._Str_3286;
        }
    }

