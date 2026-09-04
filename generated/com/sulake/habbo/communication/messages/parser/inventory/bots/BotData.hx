package com.sulake.habbo.communication.messages.parser.inventory.bots
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class BotData
    {
        var _id:Int = 0;
        var _name:String;
        var _motto:String;
        var _gender:String;
        var _figure:String;

        public function new(k:IMessageDataWrapper)
        {
            this._id = k.readInteger();
            this._name = k.readString();
            this._motto = k.readString();
            this._gender = k.readString();
            this._figure = k.readString();
        }

        public var id(get,never):Int;
function  get_id():Int
        {
            return this._id;
        }

        public var name(get,never):String;
function  get_name():String
        {
            return this._name;
        }

        public var motto(get,never):String;
function  get_motto():String
        {
            return this._motto;
        }

        public var figure(get,never):String;
function  get_figure():String
        {
            return this._figure;
        }

        public var gender(get,never):String;
function  get_gender():String
        {
            return this._gender;
        }
    }

