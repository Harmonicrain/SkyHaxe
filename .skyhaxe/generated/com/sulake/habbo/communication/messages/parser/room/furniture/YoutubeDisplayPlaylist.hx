package com.sulake.habbo.communication.messages.parser.room.furniture
;
     class YoutubeDisplayPlaylist
    {
        var _video:String;
        var _title:String;
        var _description:String;

        public function new(k:String, _arg_2:String, _arg_3:String)
        {
            this._video = k;
            this._title = _arg_2;
            this._description = _arg_3;
        }

        public var video(get,never):String;
public function  get_video():String
        {
            return this._video;
        }

        public var title(get,never):String;
public function  get_title():String
        {
            return this._title;
        }

        public var description(get,never):String;
public function  get_description():String
        {
            return this._description;
        }
    }

