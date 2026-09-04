package com.sulake.habbo.communication.messages.incoming.users
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class BadgePartData
    {
        var _id:Int = 0;
        var _fileName:String;
        var _Str_5291:String;

        public function new(k:IMessageDataWrapper=null)
        {
            this._id = k.readInteger();
            this._fileName = k.readString();
            this._Str_5291 = k.readString();
        }

        public var id(get,never):Int;
function  get_id():Int
        {
            return this._id;
        }

        public var fileName(get,never):String;
function  get_fileName():String
        {
            return this._fileName;
        }

        public var _Str_22901(get,never):String;
function  get__Str_22901():String
        {
            return this._Str_5291;
        }
    }

