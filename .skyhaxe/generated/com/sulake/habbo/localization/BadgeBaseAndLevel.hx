package com.sulake.habbo.localization
;
     class BadgeBaseAndLevel 
    {
        var _base:String = "";
        var _level:Int = 1;

        public function new(k:String)
        {
            var _local_2= (k.length - 1);
            while (((_local_2 > 0) && this.isNumber(k.charAt(_local_2))))
            {
                _local_2--;
            }
            this._base = k.substring(0, (_local_2 + 1));
            var _local_3= k.substring((_local_2 + 1), k.length);
            if (((!(_local_3 == null)) && (!(_local_3 == ""))))
            {
                this._level = ASCompat.toInt(_local_3);
            }
        }

        function isNumber(k:String):Bool
        {
            var _local_2= k.charCodeAt(0);
            return (_local_2 >= 48) && (_local_2 <= 57);
        }

        public var base(get,never):String;
public function  get_base():String
        {
            return this._base;
        }

        
        public var level(get,set):Int;
public function  get_level():Int
        {
            return this._level;
        }
public function  set_level(k:Int):Int        {
            this._level = Std.int(Math.max(1, k));
return k;
        }

        public var badgeId(get,never):String;
public function  get_badgeId():String
        {
            return this._base + Std.string(this._level);
        }
    }

