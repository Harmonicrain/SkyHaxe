package com.sulake.habbo.communication.messages.incoming.quest
;
    import com.sulake.core.communication.messages.IMessageDataWrapper;

     class QuestMessageData
    {
        var _Str_15344:String;
        var _Str_16809:Int = 0;
        var _Str_17283:Int = 0;
        var _activityPointType:Int = 0;
        var _id:Int = 0;
        var _accepted:Bool = false;
        var _type:String;
        var _Str_21549:String;
        var _Str_19127:Int = 0;
        var _Str_16765:String;
        var _Str_17312:Int = 0;
        var _totalSteps:Int = 0;
        var _Str_15970:Int = 0;
        var _sortOrder:Int = 0;
        var _Str_10924:String;
        var _Str_13604:String;
        var _easy:Bool = false;
        var _Str_16973:Date;

        public function new(k:IMessageDataWrapper)
        {
            this._Str_16973 = Date.now();
            this._Str_15344 = k.readString();
            this._Str_16809 = k.readInteger();
            this._Str_17283 = k.readInteger();
            this._activityPointType = k.readInteger();
            this._id = k.readInteger();
            this._accepted = k.readBoolean();
            this._type = k.readString();
            this._Str_21549 = k.readString();
            this._Str_19127 = k.readInteger();
            this._Str_16765 = k.readString();
            this._Str_17312 = k.readInteger();
            this._totalSteps = k.readInteger();
            this._sortOrder = k.readInteger();
            this._Str_10924 = k.readString();
            this._Str_13604 = k.readString();
            this._easy = k.readBoolean();
        }

        public static function _Str_18415(k:String):String
        {
            return "quests." + k;
        }


        public var _Str_6549(get,never):String;
function  get__Str_6549():String
        {
            return this._Str_15344;
        }

        public var localizationCode(get,never):String;
function  get_localizationCode():String
        {
            return this._Str_16765;
        }

        public var _Str_18579(get,never):Int;
function  get__Str_18579():Int
        {
            return this._Str_16809;
        }

        public var _Str_25129(get,never):Int;
function  get__Str_25129():Int
        {
            return this._Str_17283;
        }

        public var activityPointType(get,never):Int;
function  get_activityPointType():Int
        {
            return this._activityPointType;
        }

        
        public var accepted(get,set):Bool;
function  get_accepted():Bool
        {
            return this._accepted;
        }

        
        public var id(get,set):Int;
function  get_id():Int
        {
            return this._id;
        }

        public var type(get,never):String;
function  get_type():String
        {
            return this._type;
        }

        public var _Str_22072(get,never):String;
function  get__Str_22072():String
        {
            return this._Str_21549;
        }

        public var _Str_12939(get,never):Int;
function  get__Str_12939():Int
        {
            return this._Str_19127;
        }

        public var _Str_22915(get,never):Int;
function  get__Str_22915():Int
        {
            return this._Str_17312;
        }

        public var _Str_22975(get,never):Int;
function  get__Str_22975():Int
        {
            return this._totalSteps;
        }

        public var _Str_26107(get,never):Bool;
function  get__Str_26107():Bool
        {
            return this._Str_17312 == this._totalSteps;
        }

        
        public var _Str_3935(get,set):Int;
function  get__Str_3935():Int
        {
            if (this._Str_15970 < 1)
            {
                return 0;
            }
            var k= Date.now();
            var _local_2= Std.int(k.getTime() - this._Str_16973.getTime());
            var _local_3= Std.int(Math.max(0, (this._Str_15970 - Math.ffloor((_local_2 / 1000)))));
            return _local_3;
        }

        public function _Str_9246():String
        {
            return _Str_18415(this._Str_6549);
        }

        public function _Str_5688():String
        {
            return (this._Str_9246() + ".") + this._Str_16765;
        }

        public var _Str_6695(get,never):Bool;
function  get__Str_6695():Bool
        {
            return this._id < 1;
        }
function  set_id(k:Int):Int        {
            return this._id = k;
        }
function  set_accepted(k:Bool):Bool        {
            return this._accepted = k;
        }

        public var _Str_5132(get,never):Bool;
function  get__Str_5132():Bool
        {
            return this._Str_16809 >= this._Str_17283;
        }

        public var _Str_26251(get,never):Date;
function  get__Str_26251():Date
        {
            return this._Str_16973;
        }
function  set__Str_3935(k:Int):Int        {
            return this._Str_15970 = k;
        }

        public var sortOrder(get,never):Int;
function  get_sortOrder():Int
        {
            return this._sortOrder;
        }

        public var _Str_23842(get,never):String;
function  get__Str_23842():String
        {
            return this._Str_10924;
        }

        public var _Str_19427(get,never):String;
function  get__Str_19427():String
        {
            return this._Str_13604;
        }

        public var easy(get,never):Bool;
function  get_easy():Bool
        {
            return this._easy;
        }
    }

