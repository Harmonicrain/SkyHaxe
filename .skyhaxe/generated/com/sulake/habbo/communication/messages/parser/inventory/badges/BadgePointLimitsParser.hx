package com.sulake.habbo.communication.messages.parser.inventory.badges
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class BadgePointLimitsParser implements IMessageParser
    {
        var _data:Array<ASAny>;


        public function flush():Bool
        {
            this._data = new Array<ASAny>();
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            var _local_4:String = null;
            var _local_5 = 0;
            var _local_6 = 0;
            var _local_2= k.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                _local_4 = k.readString();
                _local_5 = k.readInteger();
                _local_6 = 0;
                while (_local_6 < _local_5)
                {
                    this._data.push(new BadgeAndPointLimit(_local_4, k));
                    _local_6++;
                }
                _local_3++;
            }
            return true;
        }

        public var data(get,never):Array<ASAny>;
public function  get_data():Array<ASAny>
        {
            return this._data;
        }

	public function new() {}
    }

