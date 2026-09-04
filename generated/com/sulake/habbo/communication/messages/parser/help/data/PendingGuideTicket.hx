package com.sulake.habbo.communication.messages.parser.help.data
;
    import com.sulake.habbo.help.enum._Str_2849;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class PendingGuideTicket
    {
        var _type:Int = 0;
        var _Str_21075:Int = 0;
        var _Str_20671:Bool = false;
        var _Str_14628:String;
        var _Str_14806:String;
        var _description:String;
        var _roomName:String;

        public function new(k:IMessageDataWrapper)        {
            this._type = k.readInteger();
            this._Str_21075 = k.readInteger();
            this._Str_20671 = k.readBoolean();
            switch (this._type)
            {
                case _Str_2849._Str_4268
                   | _Str_2849._Str_4749:
                    this._Str_14628 = k.readString();
                    this._Str_14806 = k.readString();
                    return;
                case _Str_2849._Str_8260:
                    if (!this._Str_17256)
                    {
                        this._Str_14628 = k.readString();
                        this._Str_14806 = k.readString();
                        this._roomName = k.readString();
                    }
                    return;
                case _Str_2849._Str_7052:
                    this._Str_14628 = k.readString();
                    this._Str_14806 = k.readString();
                    this._description = k.readString();
                    return;
            }
        }

        public var type(get,never):Int;
function  get_type():Int
        {
            return this._type;
        }

        public var _Str_20952(get,never):Int;
function  get__Str_20952():Int
        {
            return this._Str_21075;
        }

        public var _Str_17256(get,never):Bool;
function  get__Str_17256():Bool
        {
            return this._Str_20671;
        }

        public var _Str_25260(get,never):String;
function  get__Str_25260():String
        {
            return this._Str_14628;
        }

        public var _Str_25026(get,never):String;
function  get__Str_25026():String
        {
            return this._Str_14806;
        }

        public var description(get,never):String;
function  get_description():String
        {
            return this._description;
        }

        public var roomName(get,never):String;
function  get_roomName():String
        {
            return this._roomName;
        }
    }

