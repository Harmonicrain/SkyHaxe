package com.sulake.habbo.communication.messages.parser.room.action
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class ExpressionMessageParser implements IMessageParser 
    {
        var _userId:Int = 0;
        var _expressionType:Int = -1;


        public var userId(get,never):Int;
public function  get_userId():Int
        {
            return this._userId;
        }

        public var expressionType(get,never):Int;
public function  get_expressionType():Int
        {
            return this._expressionType;
        }

        public function flush():Bool
        {
            this._userId = 0;
            this._expressionType = -1;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            if (k == null)
            {
                return false;
            }
            this._userId = k.readInteger();
            this._expressionType = k.readInteger();
            return true;
        }

	public function new() {}
    }

