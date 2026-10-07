package com.sulake.habbo.communication.messages.parser.help
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class ChatReviewSessionVotingStatusMessageParser implements IMessageParser
    {
        public static inline final _Str_14199= 0;
        public static inline final _Str_18915= 1;
        public static inline final _Str_16095= 2;
        public static inline final _Str_16785= 3;
        public static inline final _Str_17026= 4;
        public static inline final _Str_17414= 5;

        var _status:Array<ASAny>;


        public function flush():Bool
        {
            this._status = null;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._status = [];
            var _local_2= k.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                this._status.push(k.readInteger());
                _local_3++;
            }
            return true;
        }

        public var status(get,never):Array<ASAny>;
public function  get_status():Array<ASAny>
        {
            return this._status;
        }

	public function new() {}
    }

