package com.sulake.habbo.communication.messages.parser.users
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.utils.Map;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class HabboGroupBadgesMessageParser implements IMessageParser
    {
        var _badges:Map;


        public function flush():Bool
        {
            if (this._badges != null)
            {
                this._badges.dispose();
                this._badges = null;
            }
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            var _local_3 = 0;
            var _local_4:String = null;
            var _local_2= k.readInteger();
            this._badges = new Map();
            var _local_5 = 0;
            while (_local_5 < _local_2)
            {
                _local_3 = k.readInteger();
                _local_4 = k.readString();
                this._badges.add(_local_3, _local_4);
                _local_5++;
            }
            return true;
        }

        public var badges(get,never):Map;
public function  get_badges():Map
        {
            var k= new Map();
            var _local_2 = 0;
            while ((_local_2 : UInt) < this._badges.length)
            {
                k.add(this._badges.getKey(_local_2), this._badges.getWithIndex(_local_2));
                _local_2++;
            }
            return k;
        }

	public function new() {}
    }

