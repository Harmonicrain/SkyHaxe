package com.sulake.habbo.communication.messages.parser.inventory.badges
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.utils.Map;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class BadgesParser implements IMessageParser
    {
        var _allBadgeCodes:Array<ASAny>;
        var _activeBadgeCodes:Array<ASAny>;
        var _badgeIds:Map;


        public function flush():Bool
        {
            this._allBadgeCodes = [];
            this._activeBadgeCodes = [];
            if (this._badgeIds != null)
            {
                this._badgeIds.dispose();
                this._badgeIds = null;
            }
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            var _local_2:Int;
            var _local_3:String;
            var _local_8:Int;
            this._allBadgeCodes = new Array<ASAny>();
            this._badgeIds = new Map();
            var _local_4= k.readInteger();
            var _local_5 = 0;
            while (_local_5 < _local_4)
            {
                _local_2 = k.readInteger();
                _local_3 = k.readString();
                this._badgeIds.add(_local_3, _local_2);
                this._allBadgeCodes.push(_local_3);
                _local_5++;
            }
            this._activeBadgeCodes = new Array<ASAny>();
            var _local_6= k.readInteger();
            var _local_7 = 0;
            while (_local_7 < _local_6)
            {
                _local_8 = k.readInteger();
                _local_3 = k.readString();
                this._activeBadgeCodes.push(_local_3);
                _local_7++;
            }
            return true;
        }

        public function getBadgeId(k:String):Int
        {
            return this._badgeIds.getValue(k);
        }

        public function getAllBadgeCodes():Array<ASAny>
        {
            return this._allBadgeCodes;
        }

        public function getActiveBadgeCodes():Array<ASAny>
        {
            return this._activeBadgeCodes;
        }

	public function new() {}
    }

