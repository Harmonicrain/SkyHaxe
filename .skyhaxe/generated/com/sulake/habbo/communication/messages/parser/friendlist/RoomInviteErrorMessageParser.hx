package com.sulake.habbo.communication.messages.parser.friendlist
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class RoomInviteErrorMessageParser implements IMessageParser
    {
        var _errorCode:Int = 0;
        var _Str_18004:Array<ASAny>;


        public function flush():Bool
        {
            this._Str_18004 = new Array<ASAny>();
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            var _local_2 = 0;
            var _local_3 = 0;
            this._errorCode = k.readInteger();
            if (this._errorCode == 1)
            {
                _local_2 = k.readInteger();
                _local_3 = 0;
                while (_local_3 < _local_2)
                {
                    this._Str_18004.push(k.readInteger());
                    _local_3++;
                }
            }
            return true;
        }

        public var errorCode(get,never):Int;
public function  get_errorCode():Int
        {
            return this._errorCode;
        }

        public var _Str_25393(get,never):Array<ASAny>;
public function  get__Str_25393():Array<ASAny>
        {
            return this._Str_18004;
        }

	public function new() {}
    }

