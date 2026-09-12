package com.sulake.habbo.communication.messages.incoming.sound
;
     class SongInfoEntry extends PlayListEntry
    {
        var _data:String = "";

        public function new(id:Int, length:Int, name:String, creator:String, data:String)
        {
            super(id, length, name, creator);
            this._data = data;
        }

        public var data(get,never):String;
public function  get_data():String
        {
            return this._data;
        }
    }

