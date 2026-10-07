package com.sulake.habbo.communication.messages.parser.navigator
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.habbo.communication.messages.incoming.navigator.EventCategory;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class UserEventCatsMessageParser implements IMessageParser
    {
        var _Str_15801:Array<ASAny>;


        public function parse(k:IMessageDataWrapper):Bool
        {
            this._Str_15801 = new Array<ASAny>();
            var _local_2= k.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                this._Str_15801.push(new EventCategory(k));
                _local_3++;
            }
            return true;
        }

        public function flush():Bool
        {
            this._Str_15801 = null;
            return true;
        }

        public var _Str_10701(get,never):Array<ASAny>;
public function  get__Str_10701():Array<ASAny>
        {
            return this._Str_15801;
        }

	public function new() {}
    }

