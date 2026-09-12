package com.sulake.habbo.communication.messages.parser.help
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class CallForHelpPendingCallsMessageParser implements IMessageParser 
    {
        var _callArray:Array<ASAny>;

        public function new()
        {
            this._callArray = new Array<ASAny>();
        }

        public var pendingCalls(get,never):Array<ASAny>;
public function  get_pendingCalls():Array<ASAny>
        {
            return this._callArray;
        }

        public var count(get,never):Int;
public function  get_count():Int
        {
            return this._callArray.length;
        }

        public function flush():Bool
        {
            this._callArray = new Array<ASAny>();
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            var _local_3 = 0;
            var _local_4:ASObject = null;
            this._callArray = new Array<ASAny>();
            var _local_2= k.readInteger();
            while (_local_3 < _local_2)
            {
                _local_4 = new ASObject();
                _local_4.callId = k.readString();
                _local_4.timeStamp = k.readString();
                _local_4.message = k.readString();
                this._callArray.push(_local_4);
                _local_3++;
            }
            return true;
        }
    }

