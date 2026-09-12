package com.sulake.habbo.communication.messages.parser.users
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.utils.Map;
    import com.sulake.habbo.communication.messages.incoming.users.RelationshipStatusInfo;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class RelationshipStatusInfoMessageParser implements IMessageParser
    {
        var _userId:Int = 0;
        var _relationshipStatusMap:Map;


        public function flush():Bool
        {
            if (this._relationshipStatusMap != null)
            {
                this._relationshipStatusMap.dispose();
                this._relationshipStatusMap = null;
            }
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            var _local_4:RelationshipStatusInfo = null;
            this._userId = k.readInteger();
            this._relationshipStatusMap = new Map();
            var _local_2= k.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                _local_4 = new RelationshipStatusInfo(k);
                this._relationshipStatusMap.add(_local_4._Str_24791, _local_4);
                _local_3++;
            }
            return true;
        }

        public var userId(get,never):Int;
public function  get_userId():Int
        {
            return this._userId;
        }

        public var relationshipStatusMap(get,never):Map;
public function  get_relationshipStatusMap():Map
        {
            return this._relationshipStatusMap;
        }

	public function new() {}
    }

