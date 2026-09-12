package com.sulake.habbo.friendbar.groupforums
;
     class StringBuffer 
    {
        static final _Str_16146:Float = ">".charCodeAt(0);
        static final _Str_18046:Float = "<".charCodeAt(0);

        var _Str_6427:Array<ASAny>;

        public function new()
        {
            this._Str_6427 = new Array<ASAny>();
        }

        public function _Str_15932(k:String):StringBuffer
        {
            var _local_3 = Math.NaN;
            var _local_2:Float = 0;
            while (_local_2 < k.length)
            {
                _local_3 = k.charCodeAt(Std.int(_local_2));
                switch (_local_3)
                {
                    case _Str_18046:
                        this.add("&lt;");
                        
                    case _Str_16146:
                        this.add("&gt;");
                        
                    default:
                        this._Str_6427.push(_local_3);
                }
                _local_2++;
            }
            return this;
        }

        public function add(k:String):StringBuffer
        {
            var _local_2:Float = 0;
            while (_local_2 < k.length)
            {
                this._Str_6427.push(k.charCodeAt(Std.int(_local_2)));
                _local_2++;
            }
            return this;
        }

        public function toString():String
        {
            return Reflect.callMethod(this, String.fromCharCode, this._Str_6427);
        }

        public var length(get,never):Int;
public function  get_length():Int
        {
            return this._Str_6427.length;
        }

        public function reset()
        {
            this._Str_6427 = new Array<ASAny>();
        }
    }

