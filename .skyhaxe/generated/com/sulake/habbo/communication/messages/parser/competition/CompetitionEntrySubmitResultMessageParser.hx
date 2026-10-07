package com.sulake.habbo.communication.messages.parser.competition
;
    import com.sulake.core.communication.messages.IMessageParser;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class CompetitionEntrySubmitResultMessageParser implements IMessageParser 
    {
        public static inline final SUBMITTED= 0;
        public static inline final ASK_FOR_SUBMIT= 1;
        public static inline final ASK_FOR_CONFIRM= 2;
        public static inline final PREREQUISITES_NOT_MET= 3;
        public static inline final ROOM_DOOR_NOT_OPEN= 4;
        public static inline final ROOM_TOO_OLD= 5;
        public static inline final ASK_FOR_ACCEPT_RULES= 6;

        var _goalId:Int = 0;
        var _goalCode:String;
        var _result:Int = 0;
        var _requiredFurnis:Array<ASAny>;
        var _missingFurnis:ASDictionary<ASAny,ASAny>;


        public function flush():Bool
        {
            this._requiredFurnis = null;
            this._missingFurnis = null;
            return true;
        }

        public function parse(k:IMessageDataWrapper):Bool
        {
            this._goalId = k.readInteger();
            this._goalCode = k.readString();
            this._result = k.readInteger();
            this._requiredFurnis = [];
            var _local_2= k.readInteger();
            var _local_3 = 0;
            while (_local_3 < _local_2)
            {
                this._requiredFurnis.push(k.readString());
                _local_3++;
            }
            this._missingFurnis = new ASDictionary<ASAny,ASAny>();
            _local_2 = k.readInteger();
            _local_3 = 0;
            while (_local_3 < _local_2)
            {
                this._missingFurnis[k.readString()] = "";
                _local_3++;
            }
            return true;
        }

        public var goalId(get,never):Int;
public function  get_goalId():Int
        {
            return this._goalId;
        }

        public var goalCode(get,never):String;
public function  get_goalCode():String
        {
            return this._goalCode;
        }

        public var result(get,never):Int;
public function  get_result():Int
        {
            return this._result;
        }

        public var requiredFurnis(get,never):Array<ASAny>;
public function  get_requiredFurnis():Array<ASAny>
        {
            return this._requiredFurnis;
        }

        public function isMissing(k:String):Bool
        {
            return !(this._missingFurnis[k] == null);
        }

	public function new() {}
    }

