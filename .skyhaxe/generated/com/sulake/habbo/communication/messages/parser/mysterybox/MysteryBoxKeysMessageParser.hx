package com.sulake.habbo.communication.messages.parser.mysterybox
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class MysteryBoxKeysMessageParser implements IMessageParser 
    {
        var _boxColor:String;
        var _keyColor:String;


        public function flush():Bool
        {
            this._boxColor = null;
            this._keyColor = null;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._boxColor = k.readString();
            this._keyColor = k.readString();
            return true;
        }

        public var boxColor(get,never):String;
public function  get_boxColor():String
        {
            return this._boxColor;
        }

        public var keyColor(get,never):String;
public function  get_keyColor():String
        {
            return this._keyColor;
        }

	public function new() {}
    }

