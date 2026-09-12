package com.sulake.habbo.communication.messages.parser.sound
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.sound.SongInfoEntry;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class TraxSongInfoMessageParser implements IMessageParser
    {
        var _songs:Array<ASAny>;


        public var songs(get,never):Array<ASAny>;
public function  get_songs():Array<ASAny>
        {
            return this._songs;
        }

        public function flush():Bool
        {
            this._songs = new Array<ASAny>();
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            var id = 0;
            var _local_3:String = null;
            var name:String = null;
            var data:String = null;
            var length = 0;
            var creator:String = null;
            var _local_10:SongInfoEntry = null;
            var _local_8= k.readInteger();
            var _local_9 = 0;
            while (_local_9 < _local_8)
            {
                id = k.readInteger();
                _local_3 = k.readString();
                name = k.readString();
                data = k.readString();
                length = k.readInteger();
                creator = k.readString();
                _local_10 = new SongInfoEntry(id, length, name, creator, data);
                this._songs.push(_local_10);
                _local_9++;
            }
            return true;
        }

	public function new() {}
    }

