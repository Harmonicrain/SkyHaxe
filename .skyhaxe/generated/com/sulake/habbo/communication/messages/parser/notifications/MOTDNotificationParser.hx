package com.sulake.habbo.communication.messages.parser.notifications
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class MOTDNotificationParser implements IMessageParser
    {
        var _messages:Array<ASAny>;


        public function flush():Bool
        {
            this._messages = new Array<ASAny>();
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            var _local_2= k.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                this._messages.push(k.readString());
                _local_3++;
            }
            return true;
        }

        public var messages(get,never):Array<ASAny>;
public function  get_messages():Array<ASAny>
        {
            return this._messages;
        }

	public function new() {}
    }

