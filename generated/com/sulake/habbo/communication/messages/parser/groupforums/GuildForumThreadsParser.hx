package com.sulake.habbo.communication.messages.parser.groupforums
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class GuildForumThreadsParser implements IMessageParser 
    {
        var _groupId:Int = 0;
        var _startIndex:Int = 0;
        var _amount:Int = 0;
        var _Str_7033:Array<ASAny>;


        public var groupId(get,never):Int;
function  get_groupId():Int
        {
            return this._groupId;
        }

        public var startIndex(get,never):Int;
function  get_startIndex():Int
        {
            return this._startIndex;
        }

        public var amount(get,never):Int;
function  get_amount():Int
        {
            return this._amount;
        }

        public var _Str_8372(get,never):Array<ASAny>;
function  get__Str_8372():Array<ASAny>
        {
            return this._Str_7033;
        }

        public function flush():Bool
        {
            this._groupId = -1;
            this._startIndex = -1;
            this._amount = -1;
            this._Str_7033 = [];
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._groupId = k.readInteger();
            this._startIndex = k.readInteger();
            this._amount = k.readInteger();
            var _local_2 = 0;
            while (_local_2 < this.amount)
            {
                this._Str_7033.push(GuildForumThread.parse(k));
                _local_2++;
            }
            return true;
        }

	public function new() {}
    }

