package com.sulake.habbo.communication.messages.parser.room.chat
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class RoomFilterSettingsMessageParser implements IMessageParser 
    {
        var _badWords:Array<ASAny>;


        public var badWords(get,never):Array<ASAny>;
function  get_badWords():Array<ASAny>
        {
            return this._badWords;
        }

        public function flush():Bool
        {
            return false;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._badWords = new Array<ASAny>();
            var _local_2= k.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                this._badWords.push(k.readString());
                _local_3++;
            }
            return false;
        }

	public function new() {}
    }

