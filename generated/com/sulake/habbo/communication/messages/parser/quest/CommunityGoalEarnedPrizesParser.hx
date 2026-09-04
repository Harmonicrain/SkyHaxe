package com.sulake.habbo.communication.messages.parser.quest
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.quest.PrizeData;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class CommunityGoalEarnedPrizesParser implements IMessageParser 
    {
        var _prizes:Array<ASAny>;


        public function flush():Bool
        {
            this._prizes = [];
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            var _local_2= k.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                this._prizes.push(new PrizeData(k));
                _local_3++;
            }
            return true;
        }

        public var prizes(get,never):Array<ASAny>;
function  get_prizes():Array<ASAny>
        {
            return this._prizes;
        }

	public function new() {}
    }

