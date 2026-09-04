package com.sulake.habbo.communication.messages.parser.groupforums
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class GetForumsListMessageParser implements IMessageParser
    {
        var _Str_9742:Int = 0;
        var _totalAmount:Int = 0;
        var _startIndex:Int = 0;
        var _amount:Int = 0;
        var _forums:Array<ASAny>;


        public var _Str_5154(get,never):Int;
function  get__Str_5154():Int
        {
            return this._Str_9742;
        }

        public var totalAmount(get,never):Int;
function  get_totalAmount():Int
        {
            return this._totalAmount;
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

        public var forums(get,never):Array<ASAny>;
function  get_forums():Array<ASAny>
        {
            return this._forums;
        }

        public function flush():Bool
        {
            this._forums = null;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._Str_9742 = k.readInteger();
            this._totalAmount = k.readInteger();
            this._startIndex = k.readInteger();
            this._amount = k.readInteger();
            this._forums = new Array<ASAny>();
            var _local_2 = 0;
            while (_local_2 < this.amount)
            {
                this._forums.push(ForumData._Str_4933(k));
                _local_2++;
            }
            return true;
        }

	public function new() {}
    }

