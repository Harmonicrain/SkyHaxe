package com.sulake.habbo.communication.messages.parser.room.furniture
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class YoutubeDisplayPlaylistsMessageParser implements IMessageParser 
    {
        var _furniId:Int = 0;
        var _playlists:Vector<YoutubeDisplayPlaylist>;
        var _selectedPlaylistId:String;


        public function flush():Bool
        {
            this._playlists = null;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._furniId = k.readInteger();
            var count= k.readInteger();
            this._playlists = new Vector<YoutubeDisplayPlaylist>(0);
            var index = 0;
            while (index < count)
            {
                this._playlists.push(new YoutubeDisplayPlaylist(k.readString(), k.readString(), k.readString()));
                index++;
            }
            this._selectedPlaylistId = k.readString();
            return true;
        }

        public var furniId(get,never):Int;
public function  get_furniId():Int
        {
            return this._furniId;
        }

        public var playlists(get,never):Vector<YoutubeDisplayPlaylist>;
public function  get_playlists():Vector<YoutubeDisplayPlaylist>
        {
            return this._playlists;
        }

        public var unknownString(get,never):String;
public function  get_unknownString():String
        {
            return this._selectedPlaylistId;
        }

	public function new() {}
    }

