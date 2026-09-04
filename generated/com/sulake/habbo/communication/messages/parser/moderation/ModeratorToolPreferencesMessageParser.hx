package com.sulake.habbo.communication.messages.parser.moderation
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class ModeratorToolPreferencesMessageParser implements IMessageParser
    {
        var _windowX:Int = 0;
        var _windowY:Int = 0;
        var _windowWidth:Int = 0;
        var _windowHeight:Int = 0;


        public var _Str_17736(get,never):Int;
function  get__Str_17736():Int
        {
            return this._windowX;
        }

        public var _Str_18137(get,never):Int;
function  get__Str_18137():Int
        {
            return this._windowY;
        }

        public var _Str_4971(get,never):Int;
function  get__Str_4971():Int
        {
            return this._windowWidth;
        }

        public var _Str_17903(get,never):Int;
function  get__Str_17903():Int
        {
            return this._windowHeight;
        }

        public function flush():Bool
        {
            this._windowX = 0;
            this._windowY = 0;
            this._windowWidth = 0;
            this._windowHeight = 0;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._windowX = k.readInteger();
            this._windowY = k.readInteger();
            this._windowWidth = k.readInteger();
            this._windowHeight = k.readInteger();
            return true;
        }

	public function new() {}
    }

