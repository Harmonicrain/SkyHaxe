package com.sulake.habbo.communication.messages.parser.newnavigator
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class NewNavigatorPreferencesParser implements IMessageParser
    {
        var _windowX:Int = 0;
        var _windowY:Int = 0;
        var _windowWidth:Int = 0;
        var _windowHeight:Int = 0;
        var _leftPaneHidden:Bool = false;
        var _resultsMode:Int = 0;


        public var _Str_17736(get,never):Int;
public function  get__Str_17736():Int
        {
            return this._windowX;
        }

        public var _Str_18137(get,never):Int;
public function  get__Str_18137():Int
        {
            return this._windowY;
        }

        public var _Str_4971(get,never):Int;
public function  get__Str_4971():Int
        {
            return this._windowWidth;
        }

        public var _Str_17903(get,never):Int;
public function  get__Str_17903():Int
        {
            return this._windowHeight;
        }

        public var _Str_25666(get,never):Bool;
public function  get__Str_25666():Bool
        {
            return this._leftPaneHidden;
        }

        public var _Str_23289(get,never):Int;
public function  get__Str_23289():Int
        {
            return this._resultsMode;
        }

        public function flush():Bool
        {
            this._windowX = 0;
            this._windowY = 0;
            this._windowWidth = 0;
            this._windowHeight = 0;
            this._leftPaneHidden = false;
            this._resultsMode = 0;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._windowX = k.readInteger();
            this._windowY = k.readInteger();
            this._windowWidth = k.readInteger();
            this._windowHeight = k.readInteger();
            this._leftPaneHidden = k.readBoolean();
            this._resultsMode = k.readInteger();
            return true;
        }

	public function new() {}
    }

