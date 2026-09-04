package com.sulake.habbo.communication.messages.parser.sound
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.sound.PlayListEntry;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class PlayListMessageParser implements IMessageParser
    {
        var _synchronizationCount:Int = 0;
        var _playlist:Array<ASAny>;


        public var synchronizationCount(get,never):Int;
function  get_synchronizationCount():Int
        {
            return this._synchronizationCount;
        }

        public var playList(get,never):Array<ASAny>;
function  get_playList():Array<ASAny>
        {
            return this._playlist;
        }

        public function flush():Bool
        {
            this._synchronizationCount = -1;
            this._playlist = [];
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            var _local_4:Int;
            var _local_5:Int;
            var _local_6:String;
            var _local_7:String;
            this._synchronizationCount = k.readInteger();
            var _local_2= k.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                _local_4 = k.readInteger();
                _local_5 = k.readInteger();
                _local_6 = k.readString();
                _local_7 = k.readString();
                this._playlist.push(new PlayListEntry(_local_4, _local_5, _local_6, _local_7));
                _local_3++;
            }
            return true;
        }

	public function new() {}
    }

