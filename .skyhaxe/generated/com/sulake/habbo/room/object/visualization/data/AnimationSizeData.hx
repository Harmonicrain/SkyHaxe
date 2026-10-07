package com.sulake.habbo.room.object.visualization.data
;
    import com.sulake.core.utils.Map;
    import com.sulake.room.utils.XMLValidator;

     class AnimationSizeData extends SizeData 
    {
        var _animations:Map = null;
        var _animationIds:Array<ASAny>;

        public function new(k:Int, _arg_2:Int)
        {
            this._animationIds = [];
            super(k, _arg_2);
            this._animations = new Map();
        }

        override public function dispose()
        {
            var k = 0;
            var _local_2:AnimationData = null;
            super.dispose();
            if (this._animations != null)
            {
                k = 0;
                while ((k : UInt) < this._animations.length)
                {
                    _local_2 = ASCompat.dynamicAs(this._animations.getWithIndex(k) , AnimationData);
                    if (_local_2 != null)
                    {
                        _local_2.dispose();
                    }
                    k++;
                }
                this._animations.dispose();
                this._animations = null;
            }
        }

        public function defineAnimations(k:com.sulake.core.utils.xml.XML):Bool
        {
            var _local_5:com.sulake.core.utils.xml.XML = null;
            var _local_6 = 0;
            var _local_7 = false;
            var _local_8:String = null;
            var _local_9:AnimationData = null;
            var _local_10 = 0;
            var _local_11 = 0;
            var _local_12:Array<ASAny> = null;
            var _local_13:Array<ASAny> = null;
            var _local_14:String = null;
            var _local_15 = 0;
            if (k == null)
            {
                return true;
            }
            var _local_2:Array<ASAny> = ["id"];
            var _local_3= k.child("animation");
            var _local_4 = 0;
            while (_local_4 < _local_3.length())
            {
                _local_5 = _local_3.at(_local_4);
                if (!XMLValidator.checkRequiredAttributes(_local_5, _local_2))
                {
                    return false;
                }
                _local_6 = ASCompat.toInt(ASCompat.xmlListToString(_local_5.attribute("id")));
                _local_7 = false;
                _local_8 = _local_5.attribute("transitionTo").toString();
                if (_local_8.length > 0)
                {
                    _local_10 = ASCompat.toInt(_local_8);
                    _local_6 = AnimationData.getTransitionToAnimationId(_local_10);
                    _local_7 = true;
                }
                _local_8 = _local_5.attribute("transitionFrom").toString();
                if (_local_8.length > 0)
                {
                    _local_11 = ASCompat.toInt(_local_8);
                    _local_6 = AnimationData.getTransitionFromAnimationId(_local_11);
                    _local_7 = true;
                }
                _local_9 = this.createAnimationData();
                if (!_local_9.initialize(_local_5))
                {
                    _local_9.dispose();
                    return false;
                }
                _local_8 = _local_5.attribute("immediateChangeFrom").toString();
                if (_local_8.length > 0)
                {
                    _local_12 = (cast _local_8.split(","));
                    _local_13 = [];
                    if (checkNullIteratee(_local_12)) for (_tmp_ in _local_12)
                    {
_local_14  = _tmp_;
                        _local_15 = ASCompat.toInt(_local_14);
                        if (_local_13.indexOf(_local_15) < 0)
                        {
                            _local_13.push(_local_15);
                        }
                    }
                    _local_9.setImmediateChanges(_local_13);
                }
                this._animations.add(_local_6, _local_9);
                if (!_local_7)
                {
                    this._animationIds.push(_local_6);
                }
                _local_4++;
            }
            return true;
        }

        function createAnimationData():AnimationData
        {
            return new AnimationData();
        }

        public function _Str_6839(k:Int):Bool
        {
            if (this._animations.getValue(k) != null)
            {
                return true;
            }
            return false;
        }

        public function _Str_17743():Int
        {
            return this._animationIds.length;
        }

        public function getAnimationId(k:Int):Int
        {
            var _local_2= this._Str_17743();
            if (((k >= 0) && (_local_2 > 0)))
            {
                return ASCompat.toInt(this._animationIds[(k % _local_2)]);
            }
            return 0;
        }

        public function _Str_12484(k:Int, _arg_2:Int):Bool
        {
            var _local_3= ASCompat.dynamicAs(this._animations.getValue(k) , AnimationData);
            if (_local_3 != null)
            {
                return _local_3._Str_12484(_arg_2);
            }
            return false;
        }

        public function _Str_9722(k:Int, _arg_2:Int):Int
        {
            var _local_3= ASCompat.dynamicAs(this._animations.getValue(k) , AnimationData);
            if (_local_3 != null)
            {
                return _local_3._Str_9722(_arg_2);
            }
            return 0;
        }

        public function getFrame(k:Int, _arg_2:Int, _arg_3:Int, _arg_4:Int):AnimationFrame
        {
            var _local_6:AnimationFrame = null;
            var _local_5= ASCompat.dynamicAs(this._animations.getValue(k) , AnimationData);
            if (_local_5 != null)
            {
                _local_6 = _local_5.getFrame(_arg_2, _arg_3, _arg_4);
                return _local_6;
            }
            return null;
        }

        public function _Str_7945(k:Int, _arg_2:Int, _arg_3:Int, _arg_4:Int, _arg_5:Int, _arg_6:Int):AnimationFrame
        {
            var _local_8:AnimationFrame = null;
            var _local_7= ASCompat.dynamicAs(this._animations.getValue(k) , AnimationData);
            if (_local_7 != null)
            {
                _local_8 = _local_7._Str_7945(_arg_2, _arg_3, _arg_4, _arg_5, _arg_6);
                return _local_8;
            }
            return null;
        }
    }

