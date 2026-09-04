package com.sulake.habbo.room.object.visualization.furniture
;
    import com.sulake.habbo.room.object.visualization.data.SizeData;
    import com.sulake.habbo.room.object.visualization.data.AnimationSizeData;
    import com.sulake.habbo.room.object.visualization.data.AnimationFrame;

     class AnimatedFurnitureVisualizationData extends FurnitureVisualizationData 
    {


        override function createSizeData(k:Int, _arg_2:Int, _arg_3:Int):SizeData
        {
            var _local_4:SizeData;
            _local_4 = new AnimationSizeData(_arg_2, _arg_3);
            return _local_4;
        }

        override function processVisualizationElement(k:SizeData, _arg_2:com.sulake.core.utils.xml.XML):Bool
        {
            var _local_3:AnimationSizeData;
            if (((k == null) || (_arg_2 == null)))
            {
                return false;
            }
            switch (_arg_2.name())
            {
                case "animations":
                    _local_3 = Std.downcast(k , AnimationSizeData);
                    if (_local_3 != null)
                    {
                        if (!_local_3.defineAnimations(_arg_2))
                        {
                            return false;
                        }
                    }
                    
                default:
                    if (!super.processVisualizationElement(k, _arg_2))
                    {
                        return false;
                    }
            }
            return true;
        }

        public function _Str_6839(k:Int, _arg_2:Int):Bool
        {
            var _local_3= Std.downcast(getSizeData(k) , AnimationSizeData);
            if (_local_3 != null)
            {
                return _local_3._Str_6839(_arg_2);
            }
            return false;
        }

        public function _Str_17743(k:Int):Int
        {
            var _local_2= Std.downcast(getSizeData(k) , AnimationSizeData);
            if (_local_2 != null)
            {
                return _local_2._Str_17743();
            }
            return 0;
        }

        public function getAnimationId(k:Int, _arg_2:Int):Int
        {
            var _local_3= Std.downcast(getSizeData(k) , AnimationSizeData);
            if (_local_3 != null)
            {
                return _local_3.getAnimationId(_arg_2);
            }
            return 0;
        }

        public function _Str_12484(k:Int, _arg_2:Int, _arg_3:Int):Bool
        {
            var _local_4= Std.downcast(getSizeData(k) , AnimationSizeData);
            if (_local_4 != null)
            {
                return _local_4._Str_12484(_arg_2, _arg_3);
            }
            return false;
        }

        public function _Str_9722(k:Int, _arg_2:Int, _arg_3:Int):Int
        {
            var _local_4= Std.downcast(getSizeData(k) , AnimationSizeData);
            if (_local_4 != null)
            {
                return _local_4._Str_9722(_arg_2, _arg_3);
            }
            return 0;
        }

        public function getFrame(k:Int, _arg_2:Int, _arg_3:Int, _arg_4:Int, _arg_5:Int):AnimationFrame
        {
            var _local_6= Std.downcast(getSizeData(k) , AnimationSizeData);
            if (_local_6 != null)
            {
                return _local_6.getFrame(_arg_2, _arg_3, _arg_4, _arg_5);
            }
            return null;
        }

        public function _Str_7945(k:Int, _arg_2:Int, _arg_3:Int, _arg_4:Int, _arg_5:Int, _arg_6:Int, _arg_7:Int):AnimationFrame
        {
            var _local_8= Std.downcast(getSizeData(k) , AnimationSizeData);
            if (_local_8 != null)
            {
                return _local_8._Str_7945(_arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7);
            }
            return null;
        }

	public function new() { super(); }
    }

