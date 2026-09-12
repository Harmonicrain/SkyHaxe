package com.sulake.habbo.room.object.visualization.data
;
    import com.sulake.core.utils.Map;
    import com.sulake.room.utils.XMLValidator;

     class AnimationData 
    {
        public static inline final DEFAULT_FRAME_NUMBER= 0;
        static inline final TRANSITION_TO_ANIMATION_OFFSET= 1000000;
        static inline final TRANSITION_FROM_ANIMATION_OFFSET= 2000000;

        var _layers:Map = null;
        var _frameCount:Int = -1;
        var _randomStart:Bool = false;
        var _immediateChanges:Array<ASAny> = null;

        public function new()
        {
            this._layers = new Map();
        }

        public static function getTransitionToAnimationId(k:Int):Int
        {
            return TRANSITION_TO_ANIMATION_OFFSET + k;
        }

        public static function getTransitionFromAnimationId(k:Int):Int
        {
            return TRANSITION_FROM_ANIMATION_OFFSET + k;
        }

        public static function isTransitionToAnimation(k:Int):Bool
        {
            return (k >= TRANSITION_TO_ANIMATION_OFFSET) && (k < TRANSITION_FROM_ANIMATION_OFFSET);
        }

        public static function isTransitionFromAnimation(k:Int):Bool
        {
            return k >= TRANSITION_FROM_ANIMATION_OFFSET;
        }


        public function dispose()
        {
            var k = 0;
            var _local_2:AnimationLayerData = null;
            if (this._layers != null)
            {
                k = 0;
                while ((k : UInt) < this._layers.length)
                {
                    _local_2 = ASCompat.dynamicAs(this._layers.getWithIndex(k) , AnimationLayerData);
                    if (_local_2 != null)
                    {
                        _local_2.dispose();
                    }
                    k++;
                }
                this._layers.dispose();
                this._layers = null;
            }
            this._immediateChanges = null;
        }

        public function setImmediateChanges(k:Array<ASAny>)
        {
            this._immediateChanges = k;
        }

        public function _Str_12484(k:Int):Bool
        {
            if (((!(this._immediateChanges == null)) && (this._immediateChanges.indexOf(k) >= 0)))
            {
                return true;
            }
            return false;
        }

        public function _Str_9722(k:Int):Int
        {
            if (!this._randomStart)
            {
                return 0;
            }
            return Std.int(Math.random() * this._frameCount);
        }

        public function initialize(k:com.sulake.core.utils.xml.XML):Bool
        {
            var _local_5:com.sulake.core.utils.xml.XML = null;
            var _local_6 = 0;
            var _local_7 = 0;
            var _local_8 = 0;
            var _local_9 = false;
            var _local_10:String = null;
            var _local_11:String = null;
            this._randomStart = false;
            if (ASCompat.toInt(ASCompat.xmlListToString(k.attribute("randomStart"))) != 0)
            {
                this._randomStart = true;
            }
            var _local_2:Array<ASAny> = ["id"];
            var _local_3= k.child("animationLayer");
            var _local_4 = 0;
            while (_local_4 < _local_3.length())
            {
                _local_5 = _local_3.at(_local_4);
                if (!XMLValidator.checkRequiredAttributes(_local_5, _local_2))
                {
                    return false;
                }
                _local_6 = ASCompat.toInt(ASCompat.xmlListToString(_local_5.attribute("id")));
                _local_7 = 1;
                _local_8 = 1;
                _local_9 = false;
                _local_10 = _local_5.attribute("loopCount").toString();
                if (_local_10.length > 0)
                {
                    _local_7 = ASCompat.toInt(_local_10);
                }
                _local_11 = _local_5.attribute("frameRepeat").toString();
                if (_local_11.length > 0)
                {
                    _local_8 = ASCompat.toInt(_local_11);
                }
                _local_9 = (!(ASCompat.toInt(ASCompat.xmlListToString(_local_5.attribute("random"))) == 0));
                if (!this.addLayer(_local_6, _local_7, _local_8, _local_9, _local_5))
                {
                    return false;
                }
                _local_4++;
            }
            return true;
        }

        function addLayer(k:Int, _arg_2:Int, _arg_3:Int, _arg_4:Bool, _arg_5:com.sulake.core.utils.xml.XML):Bool
        {
            var _local_11:com.sulake.core.utils.xml.XML = null;
            var _local_12 = 0;
            var _local_13 = false;
            var _local_14:String = null;
            var _local_15:AnimationFrameSequenceData = null;
            var _local_16:com.sulake.core.utils.xml.XMLList = null;
            var _local_17 = 0;
            var _local_18:com.sulake.core.utils.xml.XML = null;
            var _local_19 = 0;
            var _local_20 = 0;
            var _local_21 = 0;
            var _local_22 = 0;
            var _local_23 = 0;
            var _local_24:DirectionalOffsetData = null;
            var _local_6= new AnimationLayerData(_arg_2, _arg_3, _arg_4);
            var _local_7:Array<ASAny> = ["id"];
            var _local_8= _arg_5.child("frameSequence");
            var _local_9 = 0;
            while (_local_9 < _local_8.length())
            {
                _local_11 = _local_8.at(_local_9);
                _local_12 = 1;
                _local_13 = false;
                _local_14 = _local_11.attribute("loopCount").toString();
                if (_local_14.length > 0)
                {
                    _local_12 = ASCompat.toInt(_local_14);
                }
                if (ASCompat.toInt(ASCompat.xmlListToString(_local_11.attribute("random"))) != 0)
                {
                    _local_13 = true;
                }
                _local_15 = _local_6.addFrameSequence(_local_12, _local_13);
                _local_16 = _local_11.child("frame");
                _local_17 = 0;
                while (_local_17 < _local_16.length())
                {
                    _local_18 = _local_16.at(_local_17);
                    if (!XMLValidator.checkRequiredAttributes(_local_18, _local_7))
                    {
                        _local_6.dispose();
                        return false;
                    }
                    _local_19 = ASCompat.toInt(ASCompat.xmlListToString(_local_18.attribute("id")));
                    _local_20 = ASCompat.toInt(ASCompat.xmlListToString(_local_18.attribute("x")));
                    _local_21 = ASCompat.toInt(ASCompat.xmlListToString(_local_18.attribute("y")));
                    _local_22 = ASCompat.toInt(ASCompat.xmlListToString(_local_18.attribute("randomX")));
                    _local_23 = ASCompat.toInt(ASCompat.xmlListToString(_local_18.attribute("randomY")));
                    _local_24 = this.readDirectionalOffsets(_local_18);
                    _local_15.addFrame(_local_19, _local_20, _local_21, _local_22, _local_23, _local_24);
                    _local_17++;
                }
                _local_15.initialize();
                _local_9++;
            }
            _local_6.calculateLength();
            this._layers.add(k, _local_6);
            var _local_10= _local_6._Str_2185;
            if (_local_10 > this._frameCount)
            {
                this._frameCount = _local_10;
            }
            return true;
        }

        function readDirectionalOffsets(k:com.sulake.core.utils.xml.XML):DirectionalOffsetData
        {
            var _local_4:Array<ASAny> = null;
            var _local_5:com.sulake.core.utils.xml.XML = null;
            var _local_6:com.sulake.core.utils.xml.XMLList = null;
            var _local_7 = 0;
            var _local_8:com.sulake.core.utils.xml.XML = null;
            var _local_9 = 0;
            var _local_10 = 0;
            var _local_11 = 0;
            var _local_2:DirectionalOffsetData = null;
            var _local_3= k.child("offsets");
            if (_local_3.length() > 0)
            {
                _local_4 = ["direction"];
                _local_5 = _local_3.at(0);
                _local_6 = _local_5.child("offset");
                _local_7 = 0;
                while (_local_7 < _local_6.length())
                {
                    _local_8 = _local_6.at(_local_7);
                    if (XMLValidator.checkRequiredAttributes(_local_8, _local_4))
                    {
                        _local_9 = ASCompat.toInt(ASCompat.xmlListToString(_local_8.attribute("direction")));
                        _local_10 = ASCompat.toInt(ASCompat.xmlListToString(_local_8.attribute("x")));
                        _local_11 = ASCompat.toInt(ASCompat.xmlListToString(_local_8.attribute("y")));
                        if (_local_2 == null)
                        {
                            _local_2 = new DirectionalOffsetData();
                        }
                        _local_2.setOffset(_local_9, _local_10, _local_11);
                    }
                    _local_7++;
                }
            }
            return _local_2;
        }

        public function getFrame(k:Int, _arg_2:Int, _arg_3:Int):AnimationFrame
        {
            var _local_4= ASCompat.dynamicAs(this._layers.getValue(_arg_2) , AnimationLayerData);
            if (_local_4 != null)
            {
                return _local_4.getFrame(k, _arg_3);
            }
            return null;
        }

        public function _Str_7945(k:Int, _arg_2:Int, _arg_3:Int, _arg_4:Int, _arg_5:Int):AnimationFrame
        {
            var _local_6= ASCompat.dynamicAs(this._layers.getValue(_arg_2) , AnimationLayerData);
            if (_local_6 != null)
            {
                return _local_6._Str_7945(k, _arg_3, _arg_4, _arg_5);
            }
            return null;
        }
    }

