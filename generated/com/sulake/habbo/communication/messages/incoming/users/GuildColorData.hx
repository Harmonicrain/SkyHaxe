package com.sulake.habbo.communication.messages.incoming.users
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class GuildColorData
    {
        var _id:Int = 0;
        var _color:UInt = 0;

        public function new(k:IMessageDataWrapper)
        {
            this._id = k.readInteger();
            this._color = ASCompat.parseInt(k.readString(), 16);
        }

        public var id(get,never):Int;
function  get_id():Int
        {
            return this._id;
        }

        public var color(get,never):UInt;
function  get_color():UInt
        {
            return this._color;
        }

        public var red(get,never):Int;
function  get_red():Int
        {
            return (this._color >> 16) & 0xFF;
        }

        public var green(get,never):Int;
function  get_green():Int
        {
            return (this._color >> 8) & 0xFF;
        }

        public var blue(get,never):Int;
function  get_blue():Int
        {
            return (this._color >> 0) & 0xFF;
        }
    }

