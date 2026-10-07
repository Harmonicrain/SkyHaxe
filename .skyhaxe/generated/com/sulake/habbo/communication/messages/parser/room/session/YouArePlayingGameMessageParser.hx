package com.sulake.habbo.communication.messages.parser.room.session
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class YouArePlayingGameMessageParser implements IMessageParser
    {
        var _isPlaying:Bool = false;


        public var isPlaying(get,never):Bool;
public function  get_isPlaying():Bool
        {
            return this._isPlaying;
        }

        public function flush():Bool
        {
            this._isPlaying = false;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._isPlaying = k.readBoolean();
            return true;
        }

	public function new() {}
    }

