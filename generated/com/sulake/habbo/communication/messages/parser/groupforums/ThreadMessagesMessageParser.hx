package com.sulake.habbo.communication.messages.parser.groupforums
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class ThreadMessagesMessageParser implements IMessageParser
    {
        var _groupId:Int = 0;
        var _threadId:Int = 0;
        var _startIndex:Int = 0;
        var _amount:Int = 0;
        var _messages:Array<ASAny>;


        public var groupId(get,never):Int;
function  get_groupId():Int
        {
            return this._groupId;
        }

        public var threadId(get,never):Int;
function  get_threadId():Int
        {
            return this._threadId;
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

        public var messages(get,never):Array<ASAny>;
function  get_messages():Array<ASAny>
        {
            return this._messages;
        }

        public function flush():Bool
        {
            this._groupId = -1;
            this._threadId = -1;
            this._startIndex = -1;
            this._amount = -1;
            this._messages = [];
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            var _local_3:MessageData;
            this._groupId = k.readInteger();
            this._threadId = k.readInteger();
            this._startIndex = k.readInteger();
            this._amount = k.readInteger();
            var _local_2 = 0;
            while (_local_2 < this._amount)
            {
                _local_3 = MessageData._Str_4933(k);
                _local_3.groupID = this._groupId;
                _local_3.threadId = this._threadId;
                this._messages.push(_local_3);
                _local_2++;
            }
            return true;
        }

	public function new() {}
    }

