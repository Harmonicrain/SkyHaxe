package com.sulake.habbo.sound.music
;
    import com.sulake.habbo.communication.messages.incoming.sound.PlayListEntry;
    import com.sulake.habbo.sound.ISongInfo;
    import com.sulake.habbo.sound.IHabboSound;

     class SongDataEntry extends PlayListEntry implements ISongInfo
    {
        var _soundObject:IHabboSound = null;
        var _songData:String;
        var _jukeboxDiskId:Int = -1;

        public function new(k:Int, _arg_2:Int, _arg_3:String, _arg_4:String, _arg_5:IHabboSound)
        {
            this._soundObject = _arg_5;
            this._songData = "";
            super(k, _arg_2, _arg_3, _arg_4);
        }

        override public function  get_id():Int
        {
            return _id;
        }

        override public function  get_length():Int
        {
            return _length;
        }

        override public function  get_name():String
        {
            return _name;
        }

        override public function  get_creator():String
        {
            return _creator;
        }

        public var loaded(get,never):Bool;
public function  get_loaded():Bool
        {
            return (this._soundObject == null) ? false : this._soundObject.ready;
        }

        
        public var soundObject(get,set):IHabboSound;
public function  get_soundObject():IHabboSound
        {
            return this._soundObject;
        }

        
        public var songData(get,set):String;
public function  get_songData():String
        {
            return this._songData;
        }

        
        public var diskId(get,set):Int;
public function  get_diskId():Int
        {
            return this._jukeboxDiskId;
        }
public function  set_soundObject(k:IHabboSound):IHabboSound        {
            return this._soundObject = k;
        }
public function  set_songData(k:String):String        {
            return this._songData = k;
        }
public function  set_diskId(k:Int):Int        {
            return this._jukeboxDiskId = k;
        }
    }

