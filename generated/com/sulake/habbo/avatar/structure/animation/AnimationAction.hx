package com.sulake.habbo.avatar.structure.animation
;
    import flash.geom.Point;
    import com.sulake.core.utils.Map;

     class AnimationAction 
    {
        public static final DEFAULT_OFFSET:Point = new Point(0, 0);

        var _id:String;
        var _actionParts:ASDictionary<ASAny,ASAny>;
        var _bodyPartOffsets:Map;
        var _frameCount:Int = 0;
        var _frameIndexes:Array<ASAny>;

        public function new(k:com.sulake.core.utils.xml.XML)
        {
            var _local_2:com.sulake.core.utils.xml.XML;
            var _local_3:com.sulake.core.utils.xml.XML;
            var _local_4:AnimationActionPart;
            var _local_5:Int;
            var _local_6:Map;
            var _local_7:com.sulake.core.utils.xml.XML;
            var _local_8:Int;
            var _local_9:Int;
            var _local_10:Map;
            var _local_11:com.sulake.core.utils.xml.XML;
            var _local_12:String;
            var _local_13:Int;
            var _local_14:Int;
            this._bodyPartOffsets = new Map();
            this._id = k.attribute("id").toString();
            this._actionParts = new ASDictionary<ASAny,ASAny>();
            for (_tmp_ in k.child("part"))
            {
_local_2  = _tmp_;
                _local_4 = new AnimationActionPart(_local_2);
                this._actionParts[_local_2.attribute("set-type").toString()] = _local_4;
                this._frameCount = Std.int(Math.max(this._frameCount, _local_4.frames.length));
            }
            this._frameIndexes = [];
            for (_tmp_ in k.child("offsets").child("frame"))
            {
_local_3  = _tmp_;
                _local_5 = ASCompat.parseInt(_local_3.attribute("id").toString());
                this._frameCount = Std.int(Math.max(this._frameCount, _local_5));
                _local_6 = new Map();
                this._bodyPartOffsets.setValue(_local_5, _local_6);
                for (_tmp_ in _local_3.child("directions").child("direction"))
                {
_local_7  = _tmp_;
                    _local_9 = ASCompat.parseInt(_local_7.attribute("id").toString());
                    _local_10 = new Map();
                    _local_6.setValue(_local_9, _local_10);
                    for (_tmp_ in _local_7.child("bodypart"))
                    {
_local_11  = _tmp_;
                        _local_12 = _local_11.attribute("id").toString();
                        _local_13 = (_local_11.hasOwnProperty("@dx") ? ASCompat.parseInt(_local_11.attribute("dx").toString()) : 0);
                        _local_14 = (_local_11.hasOwnProperty("@dy") ? ASCompat.parseInt(_local_11.attribute("dy").toString()) : 0);
                        _local_10.setValue(_local_12, new Point(_local_13, _local_14));
                    }
                }
                this._frameIndexes.push(_local_5);
                _local_8 = ASCompat.parseInt(_local_3.attribute("repeats").toString());
                if (_local_8 > 1)
                {
                    while (--_local_8 > 0)
                    {
                        this._frameIndexes.push(_local_5);
                    }
                }
            }
        }

        public function getPart(k:String):AnimationActionPart
        {
            return ASCompat.dynamicAs(this._actionParts[k] , AnimationActionPart);
        }

        public var id(get,never):String;
function  get_id():String
        {
            return this._id;
        }

        public var parts(get,never):ASDictionary<ASAny,ASAny>;
function  get_parts():ASDictionary<ASAny,ASAny>
        {
            return this._actionParts;
        }

        public var _Str_2185(get,never):Int;
function  get__Str_2185():Int
        {
            return this._frameCount;
        }

        public function _Str_1888(k:Int, _arg_2:Int, _arg_3:String):Point
        {
            var _local_7:Point = null;
            var _local_8:Map;
            var _local_4= (_arg_2 % this._frameIndexes.length);
            var _local_5= ASCompat.toInt(this._frameIndexes[_local_4]);
            var _local_6:Map = this._bodyPartOffsets.getValue(_local_5);
            if (_local_6 != null)
            {
                _local_8 = _local_6.getValue(k);
                if (_local_8 != null)
                {
                    _local_7 = _local_8.getValue(_arg_3);
                }
            }
            return (_local_7 != null) ? _local_7 : DEFAULT_OFFSET;
        }
    }

