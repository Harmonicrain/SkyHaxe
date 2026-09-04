package com.sulake.habbo.communication.messages.incoming.room.pets
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class BreedingPetInfo 
    {
        var _webId:Int = 0;
        var _name:String;
        var _level:Int = 0;
        var _figure:String;
        var _owner:String;

        public function new(k:IMessageDataWrapper)
        {
            this._webId = k.readInteger();
            this._name = k.readString();
            this._level = k.readInteger();
            this._figure = k.readString();
            this._owner = k.readString();
        }

        public function dispose()
        {
            this._webId = 0;
            this._name = "";
            this._level = 0;
            this._figure = "";
            this._owner = "";
        }

        public var webId(get,never):Int;
function  get_webId():Int
        {
            return this._webId;
        }

        public var name(get,never):String;
function  get_name():String
        {
            return this._name;
        }

        public var level(get,never):Int;
function  get_level():Int
        {
            return this._level;
        }

        public var figure(get,never):String;
function  get_figure():String
        {
            return this._figure;
        }

        public var owner(get,never):String;
function  get_owner():String
        {
            return this._owner;
        }
    }

