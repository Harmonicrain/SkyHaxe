package com.sulake.habbo.communication.messages.parser.talent
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class TalentTrackLevelMessageParser implements IMessageParser
    {
        var _talentTrackName:String;
        var _level:Int = 0;
        var _maxLevel:Int = 0;


        public function flush():Bool
        {
            this._talentTrackName = null;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._talentTrackName = k.readString();
            this._level = k.readInteger();
            this._maxLevel = k.readInteger();
            return true;
        }

        public var talentTrackName(get,never):String;
public function  get_talentTrackName():String
        {
            return this._talentTrackName;
        }

        public var level(get,never):Int;
public function  get_level():Int
        {
            return this._level;
        }

        public var _Str_16859(get,never):Int;
public function  get__Str_16859():Int
        {
            return this._maxLevel;
        }

	public function new() {}
    }

