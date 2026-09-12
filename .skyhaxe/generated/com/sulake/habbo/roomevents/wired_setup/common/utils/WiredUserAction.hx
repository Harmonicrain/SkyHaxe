package com.sulake.habbo.roomevents.wired_setup.common.utils
;
     class WiredUserAction
    {
        public static inline final SIGN_ACTION_CODE= 10;
        public static inline final DANCE_ACTION_CODE= 11;

        public static final allWiredUserActions:Vector<WiredUserAction> = Vector.ofArray([
            new WiredUserAction("wave", 0),
            new WiredUserAction("blow", 1),
            new WiredUserAction("laugh", 2),
            new WiredUserAction("respect", 3),
            new WiredUserAction("awake", 4),
            new WiredUserAction("sleep", 5),
            new WiredUserAction("sit", 6),
            new WiredUserAction("stand", 7),
            new WiredUserAction("lay", 8),
            new WiredUserAction("sign", SIGN_ACTION_CODE, true, signCodeToString, signStringToCode),
            new WiredUserAction("dance", DANCE_ACTION_CODE, true, danceCodeToString, danceStringToCode),
            new WiredUserAction("67", 67)
        ]);

        var _name:String;
        var _code:Int = 0;
        var _hasExtra:Bool = false;
        var _extraIdToString:ASFunction;
        var _extraStringToId:ASFunction;

        public function new(name:String, code:Int, hasExtra:Bool = false, extraIdToString:ASFunction = null, extraStringToId:ASFunction = null)
        {
            this._name = name;
            this._code = code;
            this._hasExtra = hasExtra;
            this._extraIdToString = extraIdToString;
            this._extraStringToId = extraStringToId;
        }

        public static function getByCode(code:Int):WiredUserAction
        {
var action:WiredUserAction  = null;            final _iter_ = allWiredUserActions; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
action = _tmp_;
                if (action.code == code)
                {
                    return action;
                }
            }
            return null;
        }

        static function signCodeToString(code:Int):String
        {
            return Std.string(code);
        }

        static function signStringToCode(value:String):Int
        {
            return ASCompat.toInt(value);
        }

        static function danceCodeToString(code:Int):String
        {
            return "dance " + Std.string(code);
        }

        static function danceStringToCode(value:String):Int
        {
            var parts:Array<ASAny> = (cast value.split(" "));
            return parts.length > 1 ? ASCompat.toInt(parts[1]) : -1;
        }

        public var name(get,never):String;
public function  get_name():String { return this._name; }
        public var code(get,never):Int;
public function  get_code():Int { return this._code; }
        public var hasExtra(get,never):Bool;
public function  get_hasExtra():Bool { return this._hasExtra; }

        public function convertCodeToExtraString(code:Int):String
        {
            return this._extraIdToString != null ? this._extraIdToString(code) : "";
        }

        public function convertExtraStringToCode(value:String):Int
        {
            return ASCompat.toInt(this._extraStringToId != null ? ASCompat.toInt(this._extraStringToId(value) ): -1);
        }
    }

