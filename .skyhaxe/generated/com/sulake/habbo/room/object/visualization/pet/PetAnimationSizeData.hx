package com.sulake.habbo.room.object.visualization.pet
;
    import com.sulake.habbo.room.object.visualization.data.AnimationSizeData;
    import com.sulake.core.utils.Map;
    import com.sulake.room.utils.XMLValidator;
    import com.sulake.habbo.room.object.visualization.data.*;

     class PetAnimationSizeData extends AnimationSizeData 
    {
        public static inline final ANIMATION_NOT_DEFINED_ID= -1;

        var _posturesToAnimations:Map;
        var _gesturesToAnimations:Map;
        var _defaultPosture:String;

        public function new(k:Int, _arg_2:Int)
        {
            this._posturesToAnimations = new Map();
            this._gesturesToAnimations = new Map();
            super(k, _arg_2);
        }

        public function definePostures(k:com.sulake.core.utils.xml.XML):Bool
        {
            var _local_5:com.sulake.core.utils.xml.XML = null;
            var _local_6:String = null;
            var _local_7 = 0;
            if (k == null)
            {
                return false;
            }
            if (XMLValidator.checkRequiredAttributes(k, ["defaultPosture"]))
            {
                this._defaultPosture = k.attribute("defaultPosture").toString();
            }
            else
            {
                this._defaultPosture = null;
            }
            var _local_2:Array<ASAny> = ["id", "animationId"];
            var _local_3= k.child("posture");
            var _local_4 = 0;
            while (_local_4 < _local_3.length())
            {
                _local_5 = _local_3.at(_local_4);
                if (!XMLValidator.checkRequiredAttributes(_local_5, _local_2))
                {
                    return false;
                }
                _local_6 = _local_5.attribute("id").toString();
                _local_7 = ASCompat.toInt(ASCompat.xmlListToString(_local_5.attribute("animationId")));
                this._posturesToAnimations.add(_local_6, _local_7);
                if (this._defaultPosture == null)
                {
                    this._defaultPosture = _local_6;
                }
                _local_4++;
            }
            if (this._posturesToAnimations.getValue(this._defaultPosture) == null)
            {
                return false;
            }
            return true;
        }

        public function defineGestures(k:com.sulake.core.utils.xml.XML):Bool
        {
            var _local_5:com.sulake.core.utils.xml.XML = null;
            var _local_6:String = null;
            var _local_7 = 0;
            if (k == null)
            {
                return true;
            }
            var _local_2:Array<ASAny> = ["id", "animationId"];
            var _local_3= k.child("gesture");
            var _local_4 = 0;
            while (_local_4 < _local_3.length())
            {
                _local_5 = _local_3.at(_local_4);
                if (!XMLValidator.checkRequiredAttributes(_local_5, _local_2))
                {
                    return false;
                }
                _local_6 = _local_5.attribute("id").toString();
                _local_7 = ASCompat.toInt(ASCompat.xmlListToString(_local_5.attribute("animationId")));
                this._gesturesToAnimations.add(_local_6, _local_7);
                _local_4++;
            }
            return true;
        }

        public function _Str_17648(k:String):Int
        {
            if (this._posturesToAnimations.getValue(k) == null)
            {
                k = this._defaultPosture;
            }
            var _local_2= ASCompat.toInt(this._posturesToAnimations.getValue(k));
            return _local_2;
        }

        public function _Str_18284(k:String):Bool
        {
            if (k == "ded")
            {
                return true;
            }
            return false;
        }

        public function _Str_18268(k:String):Int
        {
            if (this._gesturesToAnimations.getValue(k) == null)
            {
                return ANIMATION_NOT_DEFINED_ID;
            }
            var _local_2= ASCompat.toInt(this._gesturesToAnimations.getValue(k));
            return _local_2;
        }

        public function _Str_14207(k:Int, _arg_2:Bool):String
        {
            if (((k >= 0) && ((k : UInt) < this._posturesToAnimations.length)))
            {
                return this._posturesToAnimations.getKey(k);
            }
            return _arg_2 ? this._defaultPosture : null;
        }

        public function _Str_17844(k:Int):String
        {
            if (((k >= 0) && ((k : UInt) < this._gesturesToAnimations.length)))
            {
                return this._gesturesToAnimations.getKey(k);
            }
            return null;
        }

        public function _Str_17976(k:Int):String
        {
            var _local_2:String = null;
            final _iter_ = this._gesturesToAnimations.getKeys(); if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                if (this._gesturesToAnimations.getValue(_local_2) == k)
                {
                    return _local_2;
                }
            }
            return null;
        }

        public function _Str_17398():Int
        {
            return ASCompat.toInt(this._posturesToAnimations.length);
        }

        public function _Str_16869():Int
        {
            return ASCompat.toInt(this._gesturesToAnimations.length);
        }
    }

