package com.sulake.habbo.communication.messages.parser.sound
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.sound.PlayListEntry;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class PlayListSongAddedMessageParser implements IMessageParser
    {
        var _entry:PlayListEntry;


        public var entry(get,never):PlayListEntry;
function  get_entry():PlayListEntry
        {
            return this._entry;
        }

        public function flush():Bool
        {
            this._entry = null;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._entry = new PlayListEntry(k.readInteger(), k.readInteger(), k.readString(), k.readString());
            return true;
        }

	public function new() {}
    }

