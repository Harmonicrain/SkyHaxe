package com.sulake.habbo.communication.messages.parser.avatar
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class FigureUpdateParser implements IMessageParser
    {
        var _figure:String;
        var _gender:String;


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

        public function flush():Bool
        {
            this._figure = "";
            this._gender = "";
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._figure = k.readString();
            this._gender = k.readString();
            if (ASCompat.stringAsBool(this._gender))
            {
                this._gender = this._gender.toUpperCase();
            }
            return true;
        }

	public function new() {}
    }

