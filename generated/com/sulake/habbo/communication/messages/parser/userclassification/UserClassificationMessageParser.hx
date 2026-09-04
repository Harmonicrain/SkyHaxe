package com.sulake.habbo.communication.messages.parser.userclassification
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.utils.Map;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class UserClassificationMessageParser implements IMessageParser 
    {
        var _classifiedUsersNames:Map;
        var _classifiedUsersClass:Map;


        public function flush():Bool
        {
            if (this._classifiedUsersNames != null)
            {
                this._classifiedUsersNames.dispose();
                this._classifiedUsersNames = null;
            }
            if (this._classifiedUsersClass != null)
            {
                this._classifiedUsersClass.dispose();
                this._classifiedUsersClass = null;
            }
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            var _local_3:Int;
            var _local_4:String;
            var _local_5:String;
            var _local_2= k.readInteger();
            this._classifiedUsersNames = new Map();
            this._classifiedUsersClass = new Map();
            var _local_6 = 0;
            while (_local_6 < _local_2)
            {
                _local_3 = k.readInteger();
                _local_4 = k.readString();
                _local_5 = k.readString();
                this._classifiedUsersNames.add(_local_3, _local_4);
                this._classifiedUsersClass.add(_local_3, _local_5);
                _local_6++;
            }
            return true;
        }

        public var classifiedUsernameMap(get,never):Map;
function  get_classifiedUsernameMap():Map
        {
            return this._classifiedUsersNames;
        }

        public var classifiedUserTypeMap(get,never):Map;
function  get_classifiedUserTypeMap():Map
        {
            return this._classifiedUsersClass;
        }

	public function new() {}
    }

