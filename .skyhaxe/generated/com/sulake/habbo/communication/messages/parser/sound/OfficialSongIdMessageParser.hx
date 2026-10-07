package com.sulake.habbo.communication.messages.parser.sound
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class OfficialSongIdMessageParser implements IMessageParser
    {
        var _songId:Int = 0;
        var _officialSongId:String;


        public function flush():Bool
        {
            this._songId = 0;
            this._officialSongId = "";
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._officialSongId = k.readString();
            this._songId = k.readInteger();
            return true;
        }

        public var songId(get,never):Int;
public function  get_songId():Int
        {
            return this._songId;
        }

        public var officialSongId(get,never):String;
public function  get_officialSongId():String
        {
            return this._officialSongId;
        }

	public function new() {}
    }

